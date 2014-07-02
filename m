Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaGBF1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:27:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaGBF1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:27:42 -0400
Date: Tue, 1 Jul 2014 22:27:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] firmware: read firmware size using i_size_read()
Message-ID: <20140702052722.GA7080@kroah.com>
References: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
 <cover.1402672110.git.d.kasatkin@samsung.com>
 <248c69602c96d68aea1ffb4cb75e77ec38b6b75f.1402672110.git.d.kasatkin@samsung.com>
 <CACVXFVMQYk=k8fONkoHVHo7wELK7TgWVQpKeCMAZaTyXHZgePQ@mail.gmail.com>
 <CACE9dm8AR_0S9gB13T_tydBcYtJEtXmEOc_GRx_Qtfbw+pKM2w@mail.gmail.com>
 <CACE9dm9bSLTMuaobgZNF+Xe7GxZZKjqedK91PsTjYrJWafMGiw@mail.gmail.com>
 <CACVXFVPYVXe8LXtG4L4yjzLJWoT-mhuDKRkurNmsk5W-Qq4dxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPYVXe8LXtG4L4yjzLJWoT-mhuDKRkurNmsk5W-Qq4dxQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:33:49AM +0800, Ming Lei wrote:
> On Thu, Jun 26, 2014 at 12:46 AM, Dmitry Kasatkin
> <dmitry.kasatkin@gmail.com> wrote:
> > On 13 June 2014 19:06, Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:
> >> On 13 June 2014 19:03, Ming Lei <ming.lei@canonical.com> wrote:
> >>> On Fri, Jun 13, 2014 at 11:09 PM, Dmitry Kasatkin
> >>> <d.kasatkin@samsung.com> wrote:
> >>>> There is no need to read attr because inode structure contains size
> >>>> of the file. Use i_size_read() instead.
> >>>>
> >>>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >>>
> >>> Acked-by: Ming Lei <ming.lei@canonical.com>
> >>>
> >
> >
> > Hi,
> >
> > BTW. To what tree it is applied?
> 
> Greg will take it in driver-core tree.

Yes, I'll catch up on pending patches next week, thanks.

greg k-h
