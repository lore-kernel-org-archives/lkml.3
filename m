Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaENLuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:50:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaENLuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:50:06 -0400
Message-ID: <5373586C.6030007@suse.cz>
Date: Wed, 14 May 2014 13:50:04 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: akpm@linux-foundation.org, prarit@redhat.com,
        michael.opdenacker@free-electrons.com, tkhai@yandex.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/tags.sh: add regular expression replacement pattern
 for memcg
References: <1399987613-18154-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1399987613-18154-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-13 15:26, Jianyu Zhan wrote:
> Currently, while using ctags to read code, we would get stumbled on
> PageCgroup* symbols: no definition found. And it is quite dull to
> manually dig it out.
> 
> This patch adds regular expression replacement pattern for such symbols,
> like what have done for the PageXXX flag. It will teach ctags to find
> out the definition for us.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Applied to kbuild.git#misc, thanks.

Michal
