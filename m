Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaGTVyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:54:09 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:42235 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaGTVyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:54:08 -0400
MIME-Version: 1.0
Date: Sun, 20 Jul 2014 17:54:07 -0400
Message-ID: <CAPDOMViiqPtuUV5n5L0QAwFGVcGZRgKsPjKp8eYu-4U5ECdGYQ@mail.gmail.com>
Subject: dm-cache-policy-mq.c
From: Nick Krause <xerofoify@gmail.com>
To: agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-raid@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alasdair,
There seems to be a fix me in requeue_and_update_tick.
I was wondering is the comment correct in terms of fixing
it or do we need to do it a different way?
Cheers Nick
