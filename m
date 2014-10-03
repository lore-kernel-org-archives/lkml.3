Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaJCNom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:44:42 -0400
Received: from canardo.mork.no ([148.122.252.1]:44359 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbaJCNok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:44:40 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jroedel@suse.de
Subject: Re: [PATCH] PM / Hibernate: Iterate over set bits instead of PFNs in swsusp_free()
Organization: m
References: <1412076689-7001-1-git-send-email-joro@8bytes.org>
Date: Fri, 03 Oct 2014 15:44:20 +0200
In-Reply-To: <1412076689-7001-1-git-send-email-joro@8bytes.org> (Joerg
	Roedel's message of "Tue, 30 Sep 2014 13:31:29 +0200")
Message-ID: <87r3yp2rpn.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (canardo.mork.no [IPv6:2001:4641::1]); Fri, 03 Oct 2014 15:44:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> This new version adds a !NULL check for the memory bitmaps
> before they are walked. Not doing so causes a kernel crash
> when the bitmaps are NULL.

Just to confirm:  This new version works fine for me (tested on top of
an otherwise clean v3.17-rc7).


Bjørn
