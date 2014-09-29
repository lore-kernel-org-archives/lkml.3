Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaI2OvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:51:13 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:49001 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaI2OvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:51:10 -0400
Date: Mon, 29 Sep 2014 17:49:52 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] ASoC: ssm2602: add device tree bindings
Message-ID: <20140929144952.GA12060@chokladfabriken.org>
References: <1411891072-22637-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <54291D50.30002@metafoo.de>
 <20140929143452.GA11763@chokladfabriken.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929143452.GA11763@chokladfabriken.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 05:34:52PM +0300, Stefan Kristiansson wrote:
> ... if I set it to
> "adi,ssm2604" I get id->name = "ssm2603" and id->driver_data = 1.
> 

Err, copy-paste mistake,that should have of course have read
'if I set it to "adi,ssm2604" I get id->name = "ssm2604"'
