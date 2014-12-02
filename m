Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbaLBIC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:02:29 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61208 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbaLBIC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:02:26 -0500
Date: Tue, 2 Dec 2014 13:32:14 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Willy Tarreau <willy@meta-x.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: staging: panel: suggestions needed
Message-ID: <20141202080214.GA4762@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have been looking at your panel driver, and am attaching a 20x4 alphanueric lcd to it. Will start testing it in a few days as and when I get time. Looks like, it is receiving mostly checkpatch and sparse cleanups.

Just wanted your opinion on few things I was thinking:
	1) Number of lines you have fixed to 2 and 40 char per line. since I am going to connect 20x4 , i need to remember that after displaying 20 character in 1st line, next char will come to 3rd line. instead why don't we make the option of number of line to 4 ?
	2) The lcd commands you are writing to the lcd in an escape sequence while writing to the lcd. Instead of that why don't we use ioctl for lcd commands, and writing to the device will involve only sending data to lcd ?
	3) You have given fixed minor number in your code. Any problem if we make it dynamic ?
	4) For now I am only attaching a LCD, but I also want to attach a keypad to it. Can you please let me know about the schematic of the keypad connection? I can find out from the code, but I have not yet seen the keypad code.

Waiting in anticipation of your reply.

thanks
sudip
