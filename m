Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3EXEVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 00:21:32 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60797 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3EXEVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 00:21:30 -0400
Date: Thu, 23 May 2013 23:21:26 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 6/8] Documentation: Updating a broken link in "the
 perfect patch"
To: Ben Minerds <puzzleduck@gmail.com>
Cc: greg@kroah.com, Ben Minerds <PuZZleDucK@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1369312746.git.PuZZleDucK@gmail.com>
	<95e6b8218195f2be60823ce6de5ea524b727fe11.1369312746.git.PuZZleDucK@gmail.com>
In-Reply-To: <95e6b8218195f2be60823ce6de5ea524b727fe11.1369312746.git.PuZZleDucK@gmail.com>
	(from puzzleduck@gmail.com on Thu May 23 07:49:58 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369369286.2776.16@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 07:49:58 AM, Ben Minerds wrote:
>  The link to Andrews patches were out of date. Replacing with new  
> links. Also
>  slightly reformatted to allow easier selection of links.
> 
>  Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
> ---
>  Documentation/development-process/patches/The-Perfect-Patch.txt | 8  
> ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git  
> a/Documentation/development-process/patches/The-Perfect-Patch.txt  
> b/Documentation/development-process/patches/The-Perfect-Patch.txt
> index 217a303..63eccbb 100644
> --- a/Documentation/development-process/patches/The-Perfect-Patch.txt
> +++ b/Documentation/development-process/patches/The-Perfect-Patch.txt
> @@ -160,8 +160,8 @@ Overall
> 
> 
> 
> -The patch management scripts at  
> http://www.zip.com.au/~akpm/linux/patches/
> -implement all of the above.
> +The patch management scripts here implement all of the above:
> +  https://www.kernel.org/pub/linux/kernel/people/akpm/patches/

I looked in that directory, and I'm not seeing quilt.

> -The patch management tools at  
> https://savannah.nongnu.org/projects/quilt/ also
> -implement all of the above.
> \ No newline at end of file
> +The patch management tools here implement all of the above:
> +  https://savannah.nongnu.org/projects/quilt/

This appears to be the currently location. As mentioned on line 76 of  
the current Documentation/SubmittingPatches.

I think I'd like to NAK this whole series until you read what's  
currently in the tree, please?

Rob