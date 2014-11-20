Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbaKTN5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:57:10 -0500
Received: from lists.s-osg.org ([54.187.51.154]:51055 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaKTN5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:57:08 -0500
Message-ID: <546DF325.6060507@osg.samsung.com>
Date: Thu, 20 Nov 2014 06:56:53 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Bird <tim.bird@sonymobile.com>, linux-api@vger.kernel.org,
        corbet@lwn.net
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] kselftest: Move the docs to the Documentation dir
References: <546D32D0.9090206@sonymobile.com>
In-Reply-To: <546D32D0.9090206@sonymobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 05:16 PM, Tim Bird wrote:
> 
> Also, adjust the formatting a bit, and expand the section about using
> TARGETS= on the make command line.
> 
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> ---
>  Documentation/kselftest.txt        | 69 ++++++++++++++++++++++++++++++++++++++
>  tools/testing/selftests/README.txt | 61 ---------------------------------
>  2 files changed, 69 insertions(+), 61 deletions(-)
>  create mode 100644 Documentation/kselftest.txt
>  delete mode 100644 tools/testing/selftests/README.txt
> 
> diff --git a/Documentation/kselftest.txt b/Documentation/kselftest.txt
> new file mode 100644
> index 0000000..a87d840
> --- /dev/null
> +++ b/Documentation/kselftest.txt
>

Tim,

Thanks for doing this. Looks good to me. I think you missed
Documentation maintainer. Adding linux-doc and Jon Corbet to
the thread with my ack to take this through Documentation tree.

Acked-by: shuahkh@osg.samsung.com

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
