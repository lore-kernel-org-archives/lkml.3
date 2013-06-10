Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3FJQKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:10:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55229 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3FJQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:10:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH] vmcore: disable mmap_vmcore() if CONFIG_MMU is not defined
Date: Mon, 10 Jun 2013 18:10:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <51B593C3.7030609@jp.fujitsu.com>
In-Reply-To: <51B593C3.7030609@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201306101810.37960.arnd@arndb.de>
X-Provags-ID: V02:K0:SdmIYSzDw0HqDoInj9TxwixTRznlgQUcpk7m1JIlGGz
 TMnzQuqo9hxpAmZDpABNcWC76VfZgBQjKwybIwTvv2joi5Al8F
 m4UpMkgx+rTNP9XRbHLe3/U/jydahFFdnQM1sr+Zm8Y71FCi/p
 eBrMQihfHlp5oPTFRcuVyC1reG3mZRYxTysHQLyb7cP30JMspA
 el0iNz/TLD7cbVD8dIhOeFyyoVCRWjF1+iO2asjknnAXCFnlh6
 SxCBKRiLFKtqx32zT8lrxyqUJsxJVzdvAzD2R6hyHNYK42MoOV
 SSSt0i9mLIoTpbfpeeVPvatkdRutrNbBl7tglDfplhhUp2Qm+X
 rTnMEQZ2ZCkiBgHCS/0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013, HATAYAMA Daisuke wrote:
> Also, on no-MMU configuration, because we don't export buffer for ELF
> note segment to user-space, we use vzalloc() to allocate the buffer.
> Therefore, we use differnet functions to allocate the buffer for ELF
> note segment. To avoid code duplication, introduce a helper
> alloc_elfnotes_buf().
> 
> Reported-by: Amd Bergmann <arnd@arndb.de>
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>

Thanks

Note that my name is Arnd not Amd, otherwise

Acked-by: Arnd Bergmann <arnd@arndb.de>
