Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaFXMo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:44:56 -0400
Received: from canardo.mork.no ([148.122.252.1]:57802 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaFXMoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:44:54 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, davem@davemloft.net
Subject: Re: [PATCH v2] stable_kernel_rules: Add pointer to netdev-FAQ for network patches
Organization: m
References: <1403541530.15811.1.camel@joe-AO725>
	<1403544280-21182-1-git-send-email-chiluk@canonical.com>
Date: Tue, 24 Jun 2014 14:43:59 +0200
In-Reply-To: <1403544280-21182-1-git-send-email-chiluk@canonical.com> (Dave
	Chiluk's message of "Mon, 23 Jun 2014 12:24:40 -0500")
Message-ID: <878uomwk8g.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chiluk <chiluk@canonical.com> writes:

> Stable_kernel_rules should point submitters of network stable patches to the
> netdev_FAQ.txt as requests for stable network patches should go to netdev
> first.
>
> Signed-off-by: Dave Chiluk <chiluk@canonical.com>
> ---
>  Documentation/stable_kernel_rules.txt | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
> index cbc2f03..a39a0d7 100644
> --- a/Documentation/stable_kernel_rules.txt
> +++ b/Documentation/stable_kernel_rules.txt
> @@ -29,6 +29,9 @@ Rules on what kind of patches are accepted, and which ones are not, into the
>  
>  Procedure for submitting patches to the -stable tree:
>  
> + - If the patch covers files in net/ or drivers/net please follow netdev stable
> +   sumissision guidelines as described in
      ^^^^^^^^^^^

3 is a nice number :-)


Bjørn
