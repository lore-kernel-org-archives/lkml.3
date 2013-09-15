Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3IOJBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:01:40 -0400
Received: from trent.utfs.org ([94.185.90.103]:37003 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab3IOJBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:01:39 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <eb1060ff-d56d-42b7-89f5-a459820edb82@email.android.com>
References: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org> <87r4cybio2.fsf@xmission.com> <alpine.DEB.2.11.1309100124020.6509@trent.utfs.org> <20130914111426.GB4663@cachalot> <eb1060ff-d56d-42b7-89f5-a459820edb82@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: proc hidepid=2 and SGID programs
From: Christian Kujau <lists@nerdbynature.de>
Date: Sun, 15 Sep 2013 02:01:33 -0700
To: Vasiliy Kulikov <segoon@openwall.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <2d0d35e4-0088-46bf-94b8-de09d33629ed@email.android.com>
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Kujau <lists@nerdbynature.de> wrote:
>Vasiliy Kulikov <segoon@openwall.com> 
>"pgrep sgid-program" returned nothing but "kill pics off stiff program"

Gaah, that should read "kill pid-of-sgid-program", sorry.

C.


