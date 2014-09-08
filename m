Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaIHRvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:51:11 -0400
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:50372 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbaIHRvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:51:10 -0400
Date: Mon, 8 Sep 2014 12:50:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ted Percival <ted@tedp.id.au>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, apic: Fix unmasked CPU initialization
In-Reply-To: <1410192947-6830-1-git-send-email-ted@tedp.id.au>
Message-ID: <alpine.DEB.2.11.1409081250240.29051@gentwo.org>
References: <1410192947-6830-1-git-send-email-ted@tedp.id.au>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Ted Percival wrote:

> Commit 4ba2968420fa removed the application of the CPU mask resulting
> in a hang when initializing the first CPU at boot:

Argh.

Reviewed-by: Christoph Lameter <cl@linux.com>
