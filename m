Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbbAWAGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:06:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbbAWAGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:06:35 -0500
Date: Thu, 22 Jan 2015 16:06:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        "Jenny Herbert" <jennifer.herbert@citrix.com>
Subject: Re: [PATCH 2/2] mm: add 'foreign' alias for the 'pinned' page flag
Message-Id: <20150122160633.350f22805e20c0c432755e02@linux-foundation.org>
In-Reply-To: <1421682443-20509-3-git-send-email-david.vrabel@citrix.com>
References: <1421682443-20509-1-git-send-email-david.vrabel@citrix.com>
	<1421682443-20509-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015 15:47:23 +0000 David Vrabel <david.vrabel@citrix.com> wrote:

> From: Jenny Herbert <jennifer.herbert@citrix.com>
> 
> The foreign page flag will be used by Xen guests to mark pages that
> have grant mappings of frames from other (foreign) guests.
> 
> The foreign flag is an alias for the existing (Xen-specific) pinned
> flag.  This is safe because pinned is only used on pages used for page
> tables and these cannot also be foreign.
> 

Acked-by: Andrew Morton <akpm@linux-foundation.org>
