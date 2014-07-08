Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaGHWWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:22:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaGHWV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:21:59 -0400
Date: Tue, 8 Jul 2014 15:26:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] firmware: read firmware size using i_size_read()
Message-ID: <20140708222624.GB7745@kroah.com>
References: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
 <cover.1402672110.git.d.kasatkin@samsung.com>
 <248c69602c96d68aea1ffb4cb75e77ec38b6b75f.1402672110.git.d.kasatkin@samsung.com>
 <CACVXFVMQYk=k8fONkoHVHo7wELK7TgWVQpKeCMAZaTyXHZgePQ@mail.gmail.com>
 <CACE9dm8AR_0S9gB13T_tydBcYtJEtXmEOc_GRx_Qtfbw+pKM2w@mail.gmail.com>
 <CACE9dm9bSLTMuaobgZNF+Xe7GxZZKjqedK91PsTjYrJWafMGiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACE9dm9bSLTMuaobgZNF+Xe7GxZZKjqedK91PsTjYrJWafMGiw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 07:46:41PM +0300, Dmitry Kasatkin wrote:
> On 13 June 2014 19:06, Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:
> > On 13 June 2014 19:03, Ming Lei <ming.lei@canonical.com> wrote:
> >> On Fri, Jun 13, 2014 at 11:09 PM, Dmitry Kasatkin
> >> <d.kasatkin@samsung.com> wrote:
> >>> There is no need to read attr because inode structure contains size
> >>> of the file. Use i_size_read() instead.
> >>>
> >>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >>
> >> Acked-by: Ming Lei <ming.lei@canonical.com>
> >>
> 
> 
> Hi,
> 
> BTW. To what tree it is applied?

Mine now, you should get an email soon...
