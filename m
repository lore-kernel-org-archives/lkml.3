Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3KGRgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:36:48 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51440 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3KGRgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:36:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAA25o9TaWG7Wu6uXwyapKD1oaVYqb47_9Ag7JbT-ZyQT7iaJEA@mail.gmail.com>
References: <20131107070451.GA10645@bbox>
	<CAA25o9TaWG7Wu6uXwyapKD1oaVYqb47_9Ag7JbT-ZyQT7iaJEA@mail.gmail.com>
Date: Thu, 7 Nov 2013 09:36:44 -0800
Message-ID: <CAA25o9R1EppGKMBojtWk0UHEqD3aYsNxqF+P7xfVEy1i8ameSQ@mail.gmail.com>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
From: Luigi Semenzato <semenzato@google.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 9:06 AM, Luigi Semenzato <semenzato@google.com> wrote:

-> Android 4.4 KitKat is also using zram, to better support devices with
-> less than 1 MB RAM.  (That's the news.)

Sorry, I meant 1 GB RAM.

http://dilbert.com/strips/comic/1991-09-27/
