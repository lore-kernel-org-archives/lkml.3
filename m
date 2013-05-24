Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3EXEQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 00:16:23 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65356 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3EXEQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 00:16:22 -0400
Date: Thu, 23 May 2013 23:16:19 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 5/8] Documentation: Replacing reference to broken
 submission format URL
To: Ben Minerds <puzzleduck@gmail.com>
Cc: greg@kroah.com, Ben Minerds <PuZZleDucK@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1369312746.git.PuZZleDucK@gmail.com>
	<b8531ed3e293a3dd41f5d62f02229c7dbf279a5a.1369312746.git.PuZZleDucK@gmail.com>
In-Reply-To: <b8531ed3e293a3dd41f5d62f02229c7dbf279a5a.1369312746.git.PuZZleDucK@gmail.com>
	(from puzzleduck@gmail.com on Thu May 23 07:49:57 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369368979.2776.15@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 07:49:57 AM, Ben Minerds wrote:
>  Replacing refs to broken URL with internal documentation reference,  
> and a
>  little whitespace shuffle to keep it under 80 chars wide.
> 
>  Signed-off-by: Ben Minerds <puzzleduck@gmail.com>
> ---
>  Documentation/HOWTO                   | 10 +++++-----
>  Documentation/SubmittingPatches       |  2 +-
>  Documentation/ja_JP/HOWTO             |  8 ++++----
>  Documentation/ja_JP/SubmittingPatches |  2 +-
>  Documentation/ko_KR/HOWTO             |  2 +-
>  Documentation/zh_CN/HOWTO             |  2 +-
>  Documentation/zh_CN/SubmittingPatches |  2 +-
>  7 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> index 11e597e..fba34c0 100644
> --- a/Documentation/HOWTO
> +++ b/Documentation/HOWTO
> @@ -110,11 +110,11 @@ required reading:
>      subject to scrutiny for content and style), but not following  
> them
>      will almost always prevent it.
> 
> -    Other excellent descriptions of how to create patches properly  
> are:
> -	"The Perfect Patch"
> -		 
> Documentation/development-process/patches/The-Perfect-Patch.txt
> -	"Linux kernel patch submission format"
> -		http://linux.yyz.us/patch-format.html
> +  Other excellent descriptions of how to create patches properly are:
> +    "The Perfect Patch"
> +      Documentation/development-process/patches/The-Perfect-Patch.txt
> +    "Linux kernel patch submission format"
> +       
> Documentation/development-process/patches/Patch-Submission-Format.txt

Ok, this is the third consecutive patch to do approximately the same  
thing, and now you're patching lines you added in a previous patch in  
the same series.

Breaking files up into stages helps with bisectability. Are we really  
going to "git bisect" documentation?

On the larger question of "is this a good idea", I'm leaning towards  
"no" and would like you to explain why an 8 year old description  
duplicating portions of SubmittingPatches needs to be in-tree.

Rob