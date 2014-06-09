Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbaFIIHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:07:11 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62899 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaFIIHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:07:07 -0400
Message-ID: <53956B28.7040404@penguintechs.org>
Date: Mon, 09 Jun 2014 01:07:04 -0700
From: Warren Turkal <wt@penguintechs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: possible typo
References: <539548E7.9070908@penguintechs.org> <20140609074630.GA15826@ravnborg.org>
In-Reply-To: <20140609074630.GA15826@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4ce2f36b4b06b7df569b1875c7ab834270786882
Author: Warren Turkal <wt@penguintechs.org>
Date:   Sun Jun 8 22:19:29 2014 -0700

     Fix a typo.

     Signed-off-by: Warren Turkal <wt@penguintechs.org>

diff --git a/Documentation/kbuild/modules.txt 
b/Documentation/kbuild/modules.txt
index 69372fb..3fb39e0 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -470,7 +470,7 @@ build.

  	Sometimes, an external module uses exported symbols from
  	another external module. kbuild needs to have full knowledge of
-	all symbols to avoid spliitting out warnings about undefined
+	all symbols to avoid spitting out warnings about undefined
  	symbols. Three solutions exist for this situation.

  	NOTE: The method with a top-level kbuild file is recommended

wt

On 06/09/2014 12:46 AM, Sam Ravnborg wrote:
> On Sun, Jun 08, 2014 at 10:40:55PM -0700, Warren Turkal wrote:
>> Hey,
>>
>> I think I found a typo in the kbuild docs. A one line commit can be pulled
>> from the "fix_typo" branch from the git repo @ git@github.com:wt/linux.git.
>>
>> Can someone please take a look at this branch at some point?
> No.
> Please submit this as a regular patch - see Documentation/SubmittingPatches
>
> 	Sam
>
