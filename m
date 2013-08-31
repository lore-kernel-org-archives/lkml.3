Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3HaIAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:00:22 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:52070 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3HaIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:00:21 -0400
Message-ID: <5221A28B.3060009@t-online.de>
Date: Sat, 31 Aug 2013 10:00:11 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hans Verkuil <hansverk@cisco.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [REGRESSION 3.11-rc1+] wm8775 9-001b: I2C: cannot write ??? to register
 R??
References: <521A269D.3020909@t-online.de> <521C5493.1050407@cisco.com> <521C72FF.5070902@t-online.de>
In-Reply-To: <521C72FF.5070902@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: GQePpyZXoh680wwJRjHOfEvsSw0RJfXESIV0YIlF7Qm5cj8VWKZ+Ksxa-7ur8ezgip
X-TOI-MSGID: 9ca86db6-0f1f-44c4-9bf3-09c3d3bd354b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus!

It would be nice to have head cx88fix of git.linuxtv.org/hverkuil/media_tree.git
(git.linuxtv.org/hverkuil/media_tree.git/commit/5dce3635bf803cfe9dde84e00f5f9594439e6c02)
in 3.11 as it is a trivial and tested fix for a regression introduced between 3.10 and 3.11-rc1.

see http://www.gossamer-threads.com/lists/linux/kernel/1771751?#1771751

cu,
  Knut
