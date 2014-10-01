Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaJAUHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:07:50 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34561 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaJAUHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:07:49 -0400
Date: Wed, 1 Oct 2014 13:07:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull@opensource.altera.com
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v4 0/4] regulator support for pmbus and ltc2978
Message-ID: <20141001200743.GA21388@roeck-us.net>
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 02:05:46PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> This set of patches adds regulator support for pmbus_core.c and ltc2978.c
> 
> Each output has individual on/off control.
> 
> From PMBus_Specification_Part_II_Rev_1-3_20140318.pdf: 12.1.1. OPERATION
> Command Bit [7] Bit [7] controls whether the PMBus device output is on or off.
> If bit [7] is cleared (equals 0), then the output is off.  If bit [7] is set
> (equals 1), then the output is on.
> 
> Fixes in v4 are not huge: Add device tree bindings documentation for ltc2978.
> rename _pmbus_regulator_enable to _pmbus_regulator_on_off simplify
> _pmbus_regulator_on_off code s/regulator_regulator/regulator/ fix build break
> when !CONFIG_REGULATOR remove unused #define PB_OPERATION_CONTROL_SEQ_OFF fix
> a #endif comment simplify probe code, remove added switch statement remove
> BUG_ON(), add error message and fix num_regulators
> 
> Patch 1: document device tree bindings for ltc2978
> 
> Patch 2: add two helper functions for byte pmbus byte operations * byte write
> and byte read/modify/write
> 
> Patch 3: regulator support added in pmbus_core.c and pmbus.h * regulator_ops
> functions (is_enabled, enable, and disable) * gets regulator init data from
> device tree or platform data * registers the regulators * header has a macro
> for chip drivers to build their regulator_desc data
> 
> Patch 4: changes for ltc2978.c * Add Kconfig to enable/disable ltc2978
> regulator functionality * add regulator_desc and of_regulator_match info * use
> same structs for all parts; set num_regulators appropriately.
> 
Looks like this patch got lost. I did not get it, and I don't see it on lkml
either.

Guenter
