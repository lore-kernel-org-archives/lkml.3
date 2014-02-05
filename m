Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaBESZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:25:04 -0500
Received: from mail.wdtv.com ([66.118.69.84]:45090 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaBESZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:25:01 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Re: possible viri in tarballs?
Date: Wed, 5 Feb 2014 13:24:59 -0500
References: <201402050915.34607.gheskett@wdtv.com>
In-Reply-To: <201402050915.34607.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402051324.59495.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 February 2014, Gene Heskett wrote:
>Greetings;
>
>I recently brought a daily system scan by clamscan back to life, and its
>emailing me this:
>
>/home/gene/src/linux-3.8.2/Documentation/usb/gadget_multi.txt:
>MBL_400944.UNOFFICIAL FOUND
>/home/gene/src/linux-3.12.6/Documentation/usb/gadget_multi.txt:
>MBL_400944.UNOFFICIAL FOUND
>/home/gene/src/linux-3.8.3/Documentation/usb/gadget_multi.txt:
>MBL_400944.UNOFFICIAL FOUND
>/home/gene/src/linux-3.12.9/Documentation/usb/gadget_multi.txt:
>MBL_400944.UNOFFICIAL FOUND
>/home/gene/src/linux-3.4.36/Documentation/usb/gadget_multi.txt:
>MBL_400944.UNOFFICIAL FOUND
>/home/gene/src/linux-3.0.69/Documentation/usb/gadget_multi.txt:
>MBL_400944.UNOFFICIAL FOUND
>/home/gene/src/linux-3.2.40/Documentation/usb/gadget_multi.txt:
>MBL_400944.UNOFFICIAL FOUND
>
>Repeat for several other kernel trees.
>FP or ??
>
>Cheers, Gene

Someone thought its an FP, so I took this to the clamav list and got some 
links, it is a highest threat Password revealer first seen by 

<http://www.threatexpert.com/reports.aspx?find=PSWTool.Win32.PassViewer.av&x=11&y=9>

on 12/07/2011.

Over on <http://www.malwarepatrol.net/cgi/search.pl?id=400944>

You will see more history.

So that file needs sanitized.  I was under the impression that a file with 
the .txt extension was supposed to be pure ascii text, but its loaded to 
the gills with some sort of markup crap.  And I have at least 20 copies of 
it.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

