Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbaD2Svt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:51:49 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:37848 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758435AbaD2Svr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:51:47 -0400
Date: Tue, 29 Apr 2014 13:51:45 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        akpm <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] mm/slub.c: convert vnsprintf-static to va_format
In-Reply-To: <20140429193146.34df9d8cfb14e436f9020eae@skynet.be>
Message-ID: <alpine.DEB.2.10.1404291349021.26056@gentwo.org>
References: <20140429193146.34df9d8cfb14e436f9020eae@skynet.be>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Fabian Frederick wrote:

> Inspired by Joe Perches suggestion in ntfs logging clean-up.

Looks interesting. Hope it works.

Acked-by: Christoph Lameter <cl@linux.com>
