Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3HDPtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 11:49:23 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:64526 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab3HDPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 11:49:21 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Aug 2013 11:49:21 EDT
Message-ID: <51FE768D.1030506@hetnet.nl>
Date: Sun, 04 Aug 2013 17:43:09 +0200
From: Henk de Groot <henk.de.groot@hetnet.nl>
Reply-To: henk.de.groot@hetnet.nl
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Evan Ng <evan.sin.ng@gmail.com>
CC: pe1dnn@amsat.org, gregkh@linuxfoundation.org, johanmeiring@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlags49_h2: fixed 80 line character and white
 space issue in ap_h2.c Fixed various coding style warnings found by the checkpatch.pl
 tool
References: <1375303465-3437-1-git-send-email-evan.sin.ng@gmail.com> <20130802193909.GA5405@gmail.com>
In-Reply-To: <20130802193909.GA5405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2013 15:43:08.0173 (UTC) FILETIME=[512A33D0:01CE9129]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Evan,

When reformatting the array containing  the firmware data it may be easier 
to use 8 bytes per row. It is currently it is 16 bytes per row 
(overrunning the 80 characters/line) and this just means cutting each row 
exactly in half. In your first proposal it was completely reformatted to 
an odd 11 bytes per row which makes comparison with the original during 
review much harder and it is also easier to make mistakes.

Kind regards,

Henk.

