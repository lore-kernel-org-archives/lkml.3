Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaFMLyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:54:53 -0400
Received: from mailsender.cdac.in ([196.1.113.117]:52518 "EHLO
	mailsender.cdac.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaFMLyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:54:51 -0400
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2014 07:54:50 EDT
Message-ID: <539AE266.70306@cdac.in>
Date: Fri, 13 Jun 2014 17:07:10 +0530
From: Varka Bhadram <varkab@cdac.in>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: devicetree@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org,
        linux-kernel mailing list <linux-kernel@vger.kernel.org>
Subject: device tree: compilation of device tree sources
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-CDAC-PUNE-MailScanner-ID: s5DBc41L012036
X-CDAC-PUNE-MailScanner: Found to be clean, Found to be clean
X-CDAC-PUNE-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-3.801, required 6, autolearn=disabled, ALL_TRUSTED -1.00,
	BAYES_40 -0.00, RP_MATCHES_RCVD -2.80), not spam, SpamAssassin (cached,
	score=-5.3, required 6, autolearn=disabled, ALL_TRUSTED -1.80,
	BAYES_00 -3.50)
X-CDAC-PUNE-MailScanner-Information: Please contact npsfhelp@cdac.in/mailadmin@cdac.in for more information
X-MailScanner-ID: s5DBc8Gc015338
X-CDAC-PUNE-MailScanner-From: varkab@cdac.in
X-CDAC-MailScanner-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I cloned the device tree git from: 
https://kernel.googlesource.com/pub/scm/linux/kernel/git/devicetree/devicetree-rebasing

When i try to compile the Makefile is throwing errors like this:

DTC     src/arc/abilis_tb100_dvk.dtb

dtc: invalid option -- 'i'

Usage:

     dtc [options] <input file>

Options:

     -h

         This help text

     -q

         Quiet: -q suppress warnings, -qq errors, -qqq all

     -I <input format>

         Input formats are:

             dts - device tree source text

             dtb - device tree blob

             fs - /proc/device-tree style directory

     -o <output file>

     -O <output format>

         Output formats are:

             dts - device tree source text

             dtb - device tree blob

             asm - assembler source

     -V <output version>

         Blob version to produce, defaults to 17 (relevant for dtb

         and asm output only)

     -d <output dependency file>

     -R <number>

         Make space for <number> reserve map entries (relevant for

         dtb and asm output only)

     -S <bytes>

         Make the blob at least <bytes> long (extra space)

     -p <bytes>

         Add padding to the blob of <bytes> long (extra space)

     -b <number>

         Set the physical boot cpu

     -f

         Force - try to produce output even if the input tree has errors

     -s

         Sort nodes and properties before outputting (only useful for

         comparing trees)

     -v

         Print DTC version and exit

     -H <phandle format>

         phandle formats are:

             legacy - "linux,phandle" properties only

             epapr - "phandle" properties only

             both - Both "linux,phandle" and "phandle" properties

make[1]: *** [src/arc/abilis_tb100_dvk.dtb] Error 3

make: *** [all_arc] Error 2


The way of using the dtc command is wrong.


Thanks,
Varka Bhadram

-------------------------------------------------------------------------------------------------------------------------------
[ C-DAC is on Social-Media too. Kindly follow us at:
Facebook: https://www.facebook.com/CDACINDIA & Twitter: @cdacindia ]

This e-mail is for the sole use of the intended recipient(s) and may
contain confidential and privileged information. If you are not the
intended recipient, please contact the sender by reply e-mail and destroy
all copies and the original message. Any unauthorized review, use,
disclosure, dissemination, forwarding, printing or copying of this email
is strictly prohibited and appropriate legal action will be taken.
-------------------------------------------------------------------------------------------------------------------------------

