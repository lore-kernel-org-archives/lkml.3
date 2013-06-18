Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3FRIgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:36:21 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49501 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3FRIgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:36:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130617233802.GA17517@mail.gnudd.com>
References: <cover.1371018406.git.rubini@gnudd.com>
	<3e9f6b2fb7cd202da9bbb6371b27ff302ca8b860.1371018406.git.rubini@gnudd.com>
	<20130617231606.GB12984@kroah.com>
	<20130617233802.GA17517@mail.gnudd.com>
Date: Tue, 18 Jun 2013 10:36:18 +0200
X-Google-Sender-Auth: tAwihmWiHUAEEOPDY3DwoIG-CoQ
Message-ID: <CADDK0KcnZBczz8fx2PN1aYUgSmXeBrX8Zn47Hn3O=fbbRuasRg@mail.gmail.com>
Subject: Re: [PATCH 3/8] FMC: add core bus driver
From: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        juan.david.gonzalez.cobas@cern.ch, cota@braap.org,
        siglesias@igalia.com, rob@landley.net, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 1:38 AM, Alessandro Rubini <rubini@gnudd.com> wrote:
>>> + * Released according to the GNU GPL, version 2 or any later version.
[...]
> I think we want to allow for proprietary FMC drivers. I personally
> don't feel this is a core kernel technology.  But I'll let David Cobas
> expand on CERN policies, as I'm only a consultant.

After some discussion, we think Alessandro's arguments about keeping
EXPORT_SYMBOL are sound. As mentioned, CERN policies are
non-restrictive in this sense, hence we consider correct to leave
EXPORT_SYMBOLs as they are currently. The BSD licencing for
the other, "public domain" examples is also OK.

Hope this helps,

        david
