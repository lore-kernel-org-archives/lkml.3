Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbbAUSUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:20:05 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbAUST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:19:59 -0500
Date: Wed, 21 Jan 2015 10:19:55 -0800
From: Darren Hart <dvhart@infradead.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        platform-driver-x86@vger.kernel.org,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>, kernel@savoirfairelinux.com
Subject: Re: [PATCH v2 3/3] asus-laptop: cleanup is_visible
Message-ID: <20150121181955.GA7386@vmdeb7>
References: <CAHR064jkFMd3FWxGvOrE0FfXzLHoQSb9LU8Mi_AZk-CST01Sqw@mail.gmail.com>
 <810077082.264036.1421778036663.JavaMail.root@mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <810077082.264036.1421778036663.JavaMail.root@mail>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 01:20:36PM -0500, Vivien Didelot wrote:
> Hi Corentin,
> 
> > > Use the attribute indexes and concise the if statements.
> > >
> > Why ? I really don't see that as an improvement.
> 
> The improvement is code clarity and maintainability. I'm not use we want
> to keep multiple returns and this goto thing. I think per-attribute 
> if-statements are clearer.

I have to concur with Corentin, changing to numerical indices rather than the
named atrributes makes the code harder to read in my opinion, and is more likely
to lead to mistakes than not.

-- 
Darren Hart
Intel Open Source Technology Center
