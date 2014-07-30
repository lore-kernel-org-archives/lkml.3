Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaG3O1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:27:54 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:55333 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbaG3O1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:27:52 -0400
Message-ID: <53D900DD.6060006@mev.co.uk>
Date: Wed, 30 Jul 2014 15:27:41 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <driverdev-devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/19 v2] staging: comedi: amplc_pci230: remove unnecessary
 braces
References: <1406635107-27950-14-git-send-email-abbotti@mev.co.uk> <1406721227-8144-1-git-send-email-abbotti@mev.co.uk> <20140730134153.GJ4856@mwanda> <53D8FB53.3050501@mev.co.uk> <20140730140914.GK4856@mwanda>
In-Reply-To: <20140730140914.GK4856@mwanda>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-30 15:09, Dan Carpenter wrote:
> On Wed, Jul 30, 2014 at 03:04:03PM +0100, Ian Abbott wrote:
>> On 2014-07-30 14:41, Dan Carpenter wrote:
>>> On Wed, Jul 30, 2014 at 12:53:47PM +0100, Ian Abbott wrote:
>>>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>>>> ---
>>>> v2: Be less aggressive in brace removal.  Keep them for outer nested
>>>> 'if's.  Keep them in outer control statements where the inner control
>>>> statement uses braces.
>>>
>>> Really every multi-line indent should have braces for readability.  This
>>> isn't documented anywhere, but it's normal kernel style and Greg prefers
>>> it for staging as well but I can't find the URL on google where he
>>> mentioned that.
>>
>> With this version of the patch, amplc_pci230.c conforms to that --
>> as long as you don't count comments, or splitting a simple statement
>> across multiple lines to fit within 80 columns, e.g.:
>>
>> 			if (foo)
>> 				/* do this */
>> 				bar = baz +
>> 				      qux;
>
> Heh...  I am counting comments and broken lines, though.  It's not a
> totally strict rule and it's especially not strict for broken lines.
> But we would prefer braces in those situations.

If necessary, patches 13 and 19 can be dropped entirely.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
