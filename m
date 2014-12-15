Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaLOSGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:06:14 -0500
Received: from mx02.posteo.de ([89.146.194.165]:37839 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaLOSGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:06:11 -0500
Message-ID: <548F230F.50103@posteo.de>
Date: Mon, 15 Dec 2014 19:06:07 +0100
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: peterz@infradead.org
CC: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops.h: add sign_extend64() function
References: <20141215171702.GR3337@twins.programming.kicks-ass.net> <1418666055-16657-1-git-send-email-martink@posteo.de>
In-Reply-To: <1418666055-16657-1-git-send-email-martink@posteo.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-12-15 um 18:54 schrieb Martin Kepplinger:
> This adds sign_exten64 to sign extend any signed value shorter than 64 bits
> to a s64.
I'm sorry for this typo: sign_extend64()

