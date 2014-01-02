Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaABWNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:13:47 -0500
Received: from www.sr71.net ([198.145.64.142]:52654 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaABWNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:13:46 -0500
Message-ID: <52C5E493.6090007@sr71.net>
Date: Thu, 02 Jan 2014 14:13:39 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, linux-mm@kvack.org,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCHv3 06/11] arm: use is_vmalloc_addr
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org> <1388699609-18214-7-git-send-email-lauraa@codeaurora.org>
In-Reply-To: <1388699609-18214-7-git-send-email-lauraa@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 01:53 PM, Laura Abbott wrote:
> is_vmalloc_addr already does the range checking against VMALLOC_START and
> VMALLOC_END. Use it.

FWIW, these first 6 look completely sane and should get merged
regardless of what gets done with the rest.

