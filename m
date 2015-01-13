Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbbAMJyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:54:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbbAMJym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:54:42 -0500
Date: Tue, 13 Jan 2015 11:50:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 22/40] tile: fix put_user sparse errors
Message-ID: <20150113095036.GA7152@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-23-git-send-email-mst@redhat.com>
 <54B44326.6010501@ezchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B44326.6010501@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 04:56:54PM -0500, Chris Metcalf wrote:
> Nack for this patch as-is.

Thanks, I dropped it and the next one from my tree,
looks like you are on track to fixing it all in the
tile tree.
