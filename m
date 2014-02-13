Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaBML6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:58:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbaBML6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:58:17 -0500
Date: Thu, 13 Feb 2014 12:58:12 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laszlo Papp <lpapp@kde.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a 
 platform driver
Message-ID: <20140213125812.7ce5d0c9@endymion.delvare>
In-Reply-To: <20140213111607.GK32508@lee--X1>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
	<20140213095817.GD32508@lee--X1>
	<20140213111530.2a2b4982@endymion.delvare>
	<20140213111607.GK32508@lee--X1>
Organization: Suse Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, 13 Feb 2014 11:16:07 +0000, Lee Jones wrote:
> On Thu, 13 Feb 2014, Jean Delvare wrote:
> > Guenter just did:
> > 
> > http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041224.html
> 
> Nice, FWIW:
>   Acked-by: Lee Jones <lee.jones@linaro.org>  
> 
> > Any change to the max6650 driver should go on top of his patch series
> > to avoid conflicts:
> > 
> > http://lists.lm-sensors.org/pipermail/lm-sensors/2014-February/041223.html
> 
> Do you have a tree Laszlo can rebase on top of?

Now that the patches have my Reviewed-by and your Acked-by, I believe
Guenter will add them shortly to:

http://git.kernel.org/cgit/linux/kernel/git/groeck/linux-staging.git/log/?h=hwmon-staging

-- 
Jean Delvare
Suse L3 Support
