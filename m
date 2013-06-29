Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3F2BoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 21:44:08 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63686 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3F2BoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 21:44:05 -0400
Date: Fri, 28 Jun 2013 18:39:17 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] power: charger-manager: regulator_get() never returns
 NULL.
Message-ID: <20130629013917.GB20924@lizard>
References: <1372137494-4268-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAGTfZH1HfyDOh+9wwXO_=4g38_7Y4PavxpsU9+o4vJyCUbALhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGTfZH1HfyDOh+9wwXO_=4g38_7Y4PavxpsU9+o4vJyCUbALhw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 02:54:17PM +0900, Chanwoo Choi wrote:
> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> > This patch fixes return value checking of regulator_get() in
> > charger-manager
> > driver. The API, regulator_get(), returns ERR_PTR() when it fails to get
> > regulator with given name, not NULL.
> >
> > Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

1/2 v2 and 2/2 applied.

Thanks!

Anton
