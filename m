Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3L0THn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:07:43 -0500
Received: from 2.array2.smtp.34sp.com ([46.183.9.2]:57778 "EHLO
	2.array2.smtp.34sp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab3L0THm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:07:42 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2013 14:07:42 EST
Date: Fri, 27 Dec 2013 18:59:25 +0000
From: David Woodfall <dave@dawoodfall.net>
To: linux-kernel@vger.kernel.org
Subject: Problem with cpufreq and i5 since post 3.9.0
Message-ID: <20131227185924.GH17115@Blackswan>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Authenticated-As: unrealize.co.uk
X-OriginalSMTPIP: 82.44.71.14
Smarthost: 80.82.124.206
X-34SP-MailScanner-Information: Please contact the ISP for more information
X-34SP-MailScanner-ID: 88F32FF8C3.A23DE
X-34SP-MailScanner: Found to be clean
X-34SP-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.135, required 6, BAYES_00 -1.90, LONGWORDS 2.04)
X-34SP-MailScanner-From: dave@dawoodfall.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently upgraded from 3.9.0 to 3.10.17 and found that I don't have
the same cpufreq governors available. I also tested with 3.12.6 and
3.13.0_rc5 with the same results.

3.9.0 tells me:
cat /sys/devices/system/cpu/*/cpufreq/scaling_available_governors
conservative ondemand powersave userspace performance
conservative ondemand powersave userspace performance
conservative ondemand powersave userspace performance
conservative ondemand powersave userspace performance

But any of the newer kernel versions I've tested only give me
performance and powersave.

I have selected userspace as default governor and all other governors
as built-in on all versions.

I need to either be able to use performance or use userspace and set 
for the max frequency. This is for an old application that tries to
detect cpu speed, but fails because it is from the days before 
scaling.

Can anyone tell me what I need to do with these newer kernels?

Regards

-Dave



