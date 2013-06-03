Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3FCLQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:16:18 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64157 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3FCLQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:16:16 -0400
Date: Mon, 03 Jun 2013 06:16:12 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: cover CONFIG_BINFMT_SCRIPT in init.txt
To: Andreas Mohr <andi@lisas.de>
Cc: Kris Rusocki <kszysiu@braxis.org>, linux-doc@vger.kernel.org,
        andi@lisas.de, linux-kernel@vger.kernel.org
In-Reply-To: <20130530203310.GA5097@rhlx01.hs-esslingen.de> (from
	andi@lisas.de on Thu May 30 15:33:10 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1370258172.2776.57@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 03:33:10 PM, Andreas Mohr wrote:
> On Thu, May 30, 2013 at 01:24:15PM -0600, Kris Rusocki wrote:
> > From: Kris Rusocki <kszysiu@braxis.org>
> >
> > Now that binfmt_script is configurable, explain yet another possible
> > cause of boot failure (a script w/CONFIG_BINFMT_SCRIPT != y).
> 
> Nice catch, and thanks for your effort!
> 
> It's somewhat sad to see that that file remained at only one initial  
> commit
> since 2010, thus thumbs up for your help!
> 
> Docs in general seem to be a wee bit too unmaintained.

Are you volunteering?

Rob