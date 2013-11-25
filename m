Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3KYSry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:47:54 -0500
Received: from fm1nodo5.polito.it ([130.192.180.13]:51180 "EHLO
	fm1nodo5.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3KYSrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:47:52 -0500
X-ExtScanner: Niversoft's FindAttachments (free)
Message-ID: <52939AEE.5070809@polito.it>
Date: Mon, 25 Nov 2013 19:46:06 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ima: bug fixes for Linus
References: <1385145621.9559.5.camel@dhcp-9-2-203-236.watson.ibm.com>  <1385306510.5186.7.camel@dhcp-9-2-203-236.watson.ibm.com>  <alpine.LRH.2.02.1311250943500.2259@tundra.namei.org>  <1385338461.5402.3.camel@dhcp-9-2-203-236.watson.ibm.com>  <alpine.LRH.2.02.1311251313290.2899@tundra.namei.org>  <1385380993.2398.25.camel@dhcp-9-2-203-236.watson.ibm.com> <1385387470.2488.2.camel@dhcp-9-2-203-236.watson.ibm.com> <alpine.LRH.2.02.1311260235020.9714@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1311260235020.9714@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-FEAS-SYSTEM-WL: 130.192.180.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:40 PM, James Morris wrote:
> On Mon, 25 Nov 2013, Mimi Zohar wrote:
>
>> Hi James,
>>
>> These are the "essential fixes for regressions".
>>
>> The following changes since commit 4c1cc40a2d49500d84038ff751bc6cd183e729b5:
>>
>>    Revert "KEYS: verify a certificate is signed by a 'trusted' key" (2013-11-23 16:38:17 -0800)
>>
>> are available in the git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity for-linus
>>
>> for you to fetch changes up to 72ca1bd303a5126d0ce377cff699282b6b38bd86:
>>
>>    ima: make a copy of template_fmt in template_desc_init_fields() (2013-11-25 07:32:46 -0500)
>>
>> thanks,
>>
>> Mimi
>>
>> ----------------------------------------------------------------
>> Roberto Sassu (3):
>
>>        ima: make a copy of template_fmt in template_desc_init_fields()
>
>
>> template_desc_init_fields(char *template_fmt,
>
> That should probably be const char.
>
> Also, the call to kstrdup() results in a memory leak.
>

Hi James

thanks for the comments. I'm implementing them and I will post
a new version of the patch 'ima: make a copy of template_fmt in
template_desc_init_fields()' shortly.

Roberto Sassu


>
>
>
>

