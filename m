Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbaLDRcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:32:18 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34758 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbaLDRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:32:17 -0500
Date: Thu, 4 Dec 2014 09:32:12 -0800
From: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 01/19] input: cyapa: modify code to following kernel
 code style
Message-ID: <20141204173212.GA3092@dtor-ws>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
 <1417599025-21681-2-git-send-email-dudley.dulixin@gmail.com>
 <20141204045735.GA5362@newt.localdomain>
 <CO1PR06MB078B7C0303567890795B94BD1780@CO1PR06MB078.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR06MB078B7C0303567890795B94BD1780@CO1PR06MB078.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley, Jeremiah,

On Thu, Dec 04, 2014 at 05:54:43AM +0000, Dudley Du wrote:
> Jeremiah,
> 
> I didn't submitted this fix patch, but Dmitry has been helping apply the fix patch quickly, maybe todoay or tommorrow.

The patches that I apply for the next merge window should appear first
in my 'next' branch in

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git

and then in the linux-next and eventually in mainline.

> 
> For the pathces that I made were worked based off of kernel mainline.

I resolved the conflicts and applied this 1/19 patch, next time you are
re-posting the series could you please base them off my 'next' branch?
It will help me applhy them much more easily.

Thanks!

-- 
Dmitry
