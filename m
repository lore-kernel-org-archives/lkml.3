Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3JaREf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:04:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60688 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab3JaRE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:04:28 -0400
Date: Thu, 31 Oct 2013 18:04:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: sysfs: cannot create duplicate filename /bus/i2c/drivers/tps65010
Message-ID: <20131031170419.GH10544@pd.tnic>
References: <20131031152343.GE10544@pd.tnic>
 <20131031161352.GA9587@lee--X1>
 <20131031162706.GF10544@pd.tnic>
 <20131031164956.GC9587@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131031164956.GC9587@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 09:49:56AM -0700, Lee Jones wrote:
> What h/w are you attempting to run this on?

Oh, forgot to say, sorry, this is part of my randconfig boot tests in a
kvm guest:

kvm -gdb tcp::1234 -cpu phenom -hda sid-x86_64.img -boot menu=off,order=c -m 2048 -localtime -net nic,model=rtl8139 -net user,hostfwd=tcp::1235-:22 -usbdevice tablet -kernel bzImage -append "root=/dev/sda1 debug ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200,keep console=ttyS0,115200 console=tty0" -monitor pty -serial file:/root/kvm/test-x86_64.log -snapshot -name "Debian x86_64:1235" -virtfs local,path=/tmp,mount_tag=modules,security_model=none

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
