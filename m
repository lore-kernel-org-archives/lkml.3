Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaCBJkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:40:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaCBJkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:40:20 -0500
Date: Sun, 2 Mar 2014 10:29:30 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Chew Kean Ho <kean.ho.chew@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i801: enable Intel BayTrail SMBUS
Message-ID: <20140302102930.0b46b639@endymion.delvare>
In-Reply-To: <1393603436-3494-1-git-send-email-chiau.ee.chew@intel.com>
References: <1393603436-3494-1-git-send-email-chiau.ee.chew@intel.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chew,

On Sat,  1 Mar 2014 00:03:56 +0800, Chew Chiau Ee wrote:
> From: Chew, Kean ho <kean.ho.chew@intel.com>
> 
> Add Device ID of Intel BayTrail SMBus Controller.
> 
> Signed-off-by: Chew, Kean ho <kean.ho.chew@intel.com>
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> ---
>  Documentation/i2c/busses/i2c-i801 |    1 +
>  drivers/i2c/busses/Kconfig        |    1 +
>  drivers/i2c/busses/i2c-i801.c     |    3 +++
>  3 files changed, 5 insertions(+), 0 deletions(-)
> (...)

Looks alright.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
