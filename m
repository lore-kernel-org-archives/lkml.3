Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaGVBUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:20:12 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:57270 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaGVBUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:20:10 -0400
Date: Mon, 21 Jul 2014 18:20:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
cc: Max Filippov <jcmvbkbc@gmail.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/highmem: make kmap cache coloring aware
In-Reply-To: <53CDBB01.7040007@imgtec.com>
Message-ID: <alpine.DEB.2.02.1407211819340.9778@chino.kir.corp.google.com>
References: <1405616598-14798-1-git-send-email-jcmvbkbc@gmail.com> <alpine.DEB.2.02.1407211754350.7042@chino.kir.corp.google.com> <53CDBB01.7040007@imgtec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Leonid Yegoshin wrote:

> Yes, there is one, at least for MIPS. This stuff can be a common ground for
> both platforms (MIPS and XTENSA)
> 

Needs the mips patch as a followup as justification for the change.
