Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbaHVNdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:33:03 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50256 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbaHVNdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:33:01 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: wireless: Add include guards
Organization: D03
References: <1408710414-13810-1-git-send-email-linux@rasmusvillemoes.dk>
X-Hashcash: 1:20:140822:linux-kernel@vger.kernel.org::EDi7BmvdJNH2IpYd:0000000000000000000000000000000003GKv
X-Hashcash: 1:20:140822:netdev@vger.kernel.org::EIzGJRaA9L5ZR9aU:0000000000000000000000000000000000000001qC5
X-Hashcash: 1:20:140822:linux-wireless@vger.kernel.org::pyujkpvHXgMUJojp:00000000000000000000000000000002+j6
X-Hashcash: 1:20:140822:linville@tuxdriver.com::HC/8vBngHqEFsOD1:0000000000000000000000000000000000000002SUJ
Date: Fri, 22 Aug 2014 15:32:58 +0200
In-Reply-To: <1408710414-13810-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Fri, 22 Aug 2014 14:26:54 +0200")
Message-ID: <87egw8sl85.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> The files ray_cs.h and rayctl.h both contain two thirds of what
> appears to be an include guard using the macro name RAYLINK_H (both
> lack the #define). Since RAYLINK_H is not defined anywhere, the
> guards using different macro names.
>

I need to stop using the # character in my commit messages, or at least
check that git didn't eat any of my lines.

This was supposed to be something like "... defined anywhere, the
#ifndefs are simply confusing no-ops. Add proper include guards using
different macro names".

Rasmus
