Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3GSVun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:50:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42082 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3GSVul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:50:41 -0400
Message-ID: <51E9B4A1.3080205@canonical.com>
Date: Fri, 19 Jul 2013 17:50:25 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal.mostafa@canonical.com>
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, kendatsuba@gmail.com,
        linux-input@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: [PATCH][v3.2.y][v3.5.y][3.8.y] Input: elantech - fix for newer hardware
 versions (v7)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please consider including upstream commit
9eebed7de660c0b5ab129a9de4f89d20b60de68c in the next v3.2.y, v3.5.y and
v3.8.y releases. 

It was included upstream as of v3.11-rc1.  It has been tested and
confirmed to resolve http://bugs.launchpad.net/bugs/1166442 .

commit 9eebed7de660c0b5ab129a9de4f89d20b60de68c
Author: Matteo Delfino <kendatsuba@gmail.com>
Date:   Sat Jul 6 21:52:26 2013 -0700

    Input: elantech - fix for newer hardware versions (v7)


Sincerely,
Joseph Salisbury

