Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaCGQxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:53:49 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:46869 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbaCGQxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:53:47 -0500
Message-ID: <5319F996.6090201@epfl.ch>
Date: Fri, 07 Mar 2014 17:53:42 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] checkpatch: enhance compatible string checking
References: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch> <1394208487.16156.62.camel@joe-AO722>
In-Reply-To: <1394208487.16156.62.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/07/2014 05:08 PM, Joe Perches wrote:
> On Fri, 2014-03-07 at 14:26 +0100, Florian Vaussard wrote:
>> Joe: I have split your patch to perform atomic changes. I also
>> merged one part into one of my patch. I added your S-o-B on the
>> corresponding patches, I let you check if you are OK with the changes.
> 
> Could you please send a clean V4 without my SOB and add
> Andrew Morton <akpm@linux-foundation.org> to the cc's?
> 

Do I remove your SOB from all 4 patches?

> Andrew is generally the path to get checkpatch changes
> upstream.
> 

Sure.

Regards,
Florian
