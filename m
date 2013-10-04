Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3JDCii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 22:38:38 -0400
Received: from muin.pair.com ([209.68.1.55]:52769 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab3JDCih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 22:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <1380724087-13927-14-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
	<1380724087-13927-14-git-send-email-jack@suse.cz>
Date: Thu, 3 Oct 2013 21:38:35 -0500
Message-ID: <CAOZdJXXsgUOHL9tLpY3v5Hq9+NLOxpSJxE8=6U397cKHP52n1g@mail.gmail.com>
Subject: Re: [PATCH 13/26] fsl_hypervisor: Convert ioctl_memcpy() to use get_user_pages_fast()
From: Timur Tabi <timur@tabi.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 9:27 AM, Jan Kara <jack@suse.cz> wrote:
> CC: Timur Tabi <timur@freescale.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

This seems okay, but I don't have access to hardware at the moment to test it.
