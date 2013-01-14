Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3ANNmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:42:18 -0500
Received: from nm17-vm1.bullet.mail.ird.yahoo.com ([77.238.189.206]:26927 "EHLO
	nm17-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288Ab3ANNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:42:17 -0500
X-Yahoo-Newman-Id: 604198.5502.bm@smtp124.mail.ird.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: 2oRASzUVM1mcz75aFn0ay5lKIuaFrywJxLmkNYFZTkqJbiU
 VZpNAjb7ii9aEMC3l_AvZ0rY5DWXx5hbPK2VDopMjArUyXPfoC96HJPa4IEj
 pSU6sKl.9krJZA4FERnwSs45nGb18oRAZRISYL5SfheZygQvWOYm7iYpaOCs
 7IvZsZhr7X7CloiijMcjDQsD.byfoObXG1aODasYB4GtEnp4_H8v3ziGqOnS
 fhfthwHl3swx4Srvr5b2zN0oU6f0WFS63LIB_l8u08_Rkh9K33LogWwK_sQX
 GGFVjuSxVxEGWRHkDZNC8epc4MRTDWBEuk30M_Lr3jqAzKQsQe6D.6MBA_kR
 p8zozQNO9jqTH.q2mpIKsvnmfJAIqgMoqno35b2H2I3qmzCprKxHLP4ZSTiy
 is6cq0iJURhsMWee31CyRjAj.o.KJJxpNfrCYIWh1umoitaeTqqkvDkbI4O6
 ll3IhqTcwdXCeqglplj6hxccsDIgnMr2OTqRPKA--
X-Yahoo-SMTP: mOFZFAuswBAG4_8a4ZBj.Wmvw2Qxc4R7nmE-
From: Schrober <franzschrober@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch.pl "uninitialized value"
Date: Mon, 14 Jan 2013 14:42:14 +0100
Message-ID: <8765116.NauFasYmb5@bentobox>
User-Agent: KMail/4.8.4 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems the current version of checkpatch.pl in linux-next ist broken. I get
a lot of

Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3383.
Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3386.
Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3383.
Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3386.
Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3383.
Use of uninitialized value $ms_size in pattern match (m//) at ./scripts/checkpatch.pl line 3386.
-- 
Franz Schrober
