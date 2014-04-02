Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161056AbaDBXVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:21:36 -0400
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:52969 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030676AbaDBXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:21:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:3870:3872:4321:5007:6119:7652:7903:8829:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12679:12740:13255:14093:14097:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: curve76_820a271eb2c39
X-Filterd-Recvd-Size: 3259
Message-ID: <1396480892.32040.17.camel@joe-AO722>
Subject: Re: [PATCH] driver: staging: wlan-ng: Fixed Breaking long lines and
 strings style rule
From: Joe Perches <joe@perches.com>
To: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, silentquote@gmail.com
Date: Wed, 02 Apr 2014 16:21:32 -0700
In-Reply-To: <1396480678-32036-1-git-send-email-shehabaldin.sherif@gmail.com>
References: <1396480678-32036-1-git-send-email-shehabaldin.sherif@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 01:17 +0200, Sherif Shehab Aldin wrote:
> Fixed coding style rule "Breaking long lines and strings" for hfa384x_usb.c

Please use "scripts/checkpatch.pl --strict" on patches
to files in drivers/staging.

CHECK: Alignment should match open parenthesis
#75: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:646:
+	pr_debug("cmdresult:status=0x%04x resp0=0x%04x resp1=0x%04x resp2=0x%04x\n",
+			result->status, result->resp0,

CHECK: Alignment should match open parenthesis
#99: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:1383:
+	pr_debug("cmdreq: cmd=0x%04x parm0=0x%04x parm1=0x%04x parm2=0x%04x\n",
+			cmd->cmd, cmd->parm0, cmd->parm1, cmd->parm2);

CHECK: Alignment should match open parenthesis
#109: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2019:
+	netdev_info(hw->wlandev->netdev,
+			"Download %d bytes to flash @0x%06x\n", len, daddr);

CHECK: Alignment should match open parenthesis
#120: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2030:
+	netdev_warn(hw->wlandev->netdev,
+			"dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,

CHECK: Alignment should match open parenthesis
#133: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2065:
+			netdev_err(hw->wlandev->netdev,
+					"download(NV,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",

CHECK: Alignment should match open parenthesis
#154: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2354:
+	netdev_info(hw->wlandev->netdev, "Writing %d bytes to ram @0x%06x\n",
+			len, daddr);

CHECK: Alignment should match open parenthesis
#164: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2465:
+				netdev_err(hw->wlandev->netdev,
+						"pdrlen invalid=%d\n", pdrlen);

CHECK: Alignment should match open parenthesis
#174: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2788:
+		netdev_err(hw->wlandev->netdev,
+				"submit_tx_urb() failed, error=%d\n", ret);

CHECK: Alignment should match open parenthesis
#195: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:4143:
+			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
+					pdrcode);

CHECK: Alignment should match open parenthesis
#202: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:4148:
+			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
+					pdrcode);

total: 0 errors, 2 warnings, 10 checks, 127 lines checked


