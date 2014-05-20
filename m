Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaETSiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:38:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53091 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbaETSiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:38:11 -0400
Message-ID: <537BA0FF.3000504@zytor.com>
Date: Tue, 20 May 2014 11:37:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 3/4] x86,mm: Improve _install_special_mapping and fix
 x86 vdso naming
References: <cover.1400538962.git.luto@amacapital.net> <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
In-Reply-To: <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 03:58 PM, Andy Lutomirski wrote:
> 
> As a side effect, the vvar area will show up in core dumps.  This
> could be considered weird and is fixable.  Thoughts?
> 

On this issue... I don't know if this is likely to break anything.  My
suggestion is that we accept it as-is but be prepared to deal with it if
it breaks something.
	
	-hpa


