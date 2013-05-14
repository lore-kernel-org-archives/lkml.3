Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3ENGZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:25:32 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45683 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3ENGZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:25:30 -0400
MIME-Version: 1.0
In-Reply-To: <35557711-A88D-4226-B3C6-3787573F5403@dilger.ca>
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
	<20130510045049.GU24635@dastard>
	<CAEsagEism-SQB9LRC+EuPLoBiFOEHc0peLjh3cDxwrNe3Jz=2w@mail.gmail.com>
	<20130511212608.GA26298@thunk.org>
	<CAEsagEiFWxnLXWu7dH7jfH7xd4cRVaUdJr4zB+Rkk7V1kEemmA@mail.gmail.com>
	<35557711-A88D-4226-B3C6-3787573F5403@dilger.ca>
Date: Mon, 13 May 2013 23:25:28 -0700
Message-ID: <CAEsagEhwKDNiENPVa4C+LvXOViMrkVz_prsDyUn8_J=VuToqMA@mail.gmail.com>
Subject: Re: Tux3 Report: Faster than tmpfs, what?
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tux3@tux3.org" <tux3@tux3.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting, Andreas. We don't do anything as heavyweight as
allocating an inode in this path, just mark the inode dirty (which
puts it on a list) and set a bit in the inode flags.

Regards,

Daniel
