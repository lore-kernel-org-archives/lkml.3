Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaBPRGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 12:06:14 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:33477 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaBPRGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:06:13 -0500
MIME-Version: 1.0
Date: Sun, 16 Feb 2014 19:06:12 +0200
Message-ID: <CA+ydwtp0MiXFwKL5u-mByvUngpzqp_dLyW8JkBNbvF2NG-aiKg@mail.gmail.com>
Subject: BUG: Bad rss-counter state mm:ffff88005f936c00 idx:0 val:1
From: Tommi Rantala <tt.rantala@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Noticed the following kernel message while fuzzing
3.14.0-rc2-00488-gca03339 with trinity. Should I be worried?

[40879.796336] BUG: Bad rss-counter state mm:ffff88005f936c00 idx:0 val:1

Tommi
