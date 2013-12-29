Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3L2Clo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:41:44 -0500
Received: from mail.wdtv.com ([66.118.69.84]:43030 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab3L2Cln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:41:43 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Git puzzle
Date: Sat, 28 Dec 2013 21:41:40 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312282141.40725.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys, I need to setup a bisect using git but the man pages aren't 
giving me what I need to know.  Mainly I have no clue what the URL for the 
git repos looks like, I've been downloading and building the tarballs from 
kernel.org all this time.

Assuming I start with fresh git pull of 3.8.2 which worked, working toward 
3.8.3 which doesn't, and I have the disk space chowned to me, what is the 
exact syntax to pull a clone of 3.8.2, and then do a bisect to 3.8.3 where 
the microcode update for an AMD phenom doesn't work. Skipping fwd to 3.12.0 
it still isn't working.

Thanks for any help.  And Linus, it you're copying this list, happy 44th 
birthday today.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

Congratulations are in order for Tom Reid.

He says he just found out he is the winner of the 2021 Psychic of the
Year award.
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
