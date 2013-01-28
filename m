Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3A1XzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:55:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3A1Xy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:54:59 -0500
Date: Mon, 28 Jan 2013 15:54:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Anton Arapov <anton@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/11] ksm: NUMA trees and page migration
Message-Id: <20130128155452.16882a6e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 17:53:10 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> Here's a KSM series

Sanity check: do you have a feeling for how useful KSM is? 
Performance/space improvements for typical (or atypical) workloads? 
Are people using it?  Successfully?

IOW, is it justifying itself?
