Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610Ab3CHSLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:11:39 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52988 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933621Ab3CHSLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:11:38 -0500
Message-ID: <513A29D8.3080503@lwfinger.net>
Date: Fri, 08 Mar 2013 12:11:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Question about checking a pointer for validity
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am chasing what I suspect is a firmware error for the Realtek RTL8723AE 
device. The symptom is that the RX buffer is corrupted, and I get a kernel panic 
due to a bad pointer in an interrupt routine.

I am currently checking that pointer for NULL, which is catching some of the 
situations, but I am still getting panics from non-NULL pointers that do not 
point to a valid address.

Is there any way to test a pointer for validity that will not crash the system 
if it is bad?

Thanks,

Larry
