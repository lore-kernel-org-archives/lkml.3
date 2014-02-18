Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaBRURA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:17:00 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:62049 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaBRUQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:16:58 -0500
MIME-Version: 1.0
In-Reply-To: <53021E87.6020607@citrix.com>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
 <1392433180-16052-5-git-send-email-mcgrof@do-not-panic.com> <53021E87.6020607@citrix.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Feb 2014 12:16:36 -0800
X-Google-Sender-Auth: vWXjrbkz0t0puuVs9Pzl26PMphg
Message-ID: <CAB=NE6WwPfPi-8Yudxs4-OA2LPOjo8-XxUiVbtu6=BQ8FhEEOA@mail.gmail.com>
Subject: Re: [Xen-devel] [RFC v2 4/4] xen-netback: skip IPv4 and IPv6 interfaces
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>, xen-devel@lists.xenproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 6:36 AM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> There is a valid scenario to put IP addresses on the backend VIFs:
>
> http://wiki.xen.org/wiki/Xen_Networking#Routing

This is useful thanks!

> Also, the backend is not necessarily Dom0, you can connect two guests with
> backend/frontend pairs.

Can you elaborate a bit more on this type of setup?

  Luis
