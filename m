Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbbAWQzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:55:19 -0500
Received: from smtp102.biz.mail.bf1.yahoo.com ([98.139.221.61]:43763 "EHLO
	smtp102.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbbAWQzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:55:16 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3hnkZvMVM1nuwtywzuXxpaBkGyMDwAXrjAPy7FqxBZGnjDT
 hdVP.lFW3YhG7nexIC0A1Tp8xrEhr7MpFJRiO4QKIhdrdK42yeHICcy.tu77
 OYcztZ0MjcukOWaSuxS6IUGR1x_atRbyf8FX5CLH1fvKdvkKFuHlxDo.qY3e
 42m86vMq3yPz74Ipo.YqghM_dbKhdRLacxHnlh3P3m9Kpn1Qk_9na8QyH8Fj
 px.REvgmzNUPcJxKonzQHTe5nCDjlgxG57SyTeMXNALGGohYE4nUlHPZbpsZ
 doh4tYHyKzQJlIdp68cmvsIomkh6hNk2gNxEk3u_6n9pfeNtGtypI9a_Qf8u
 .QvcoUx5juDtUn94GGo4q4t.nsG_pPzihmNi6FZczrqxgDi.pDQGmSFiwg2d
 tjIGdFujVct9vWBCJ8d0AjkUCa5YpPHlR7Xc.FHxzwjDw9X.nbl05Lpri1N2
 ToaAbPXMxPqwcSSDdDdt0rqKuLwf1w0GLCZweYRWdUJwV_kGuRE12sxhOjIT
 hJ3uHXUXmvvtYjTEtWp3p
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54C27CF2.8060609@schaufler-ca.com>
Date: Fri, 23 Jan 2015 08:55:14 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, james.l.morris@oracle.com,
        serge@hallyn.com,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: randconfig build error with next-20150123, in security/smack/smack_netfilter.c
References: <CA+r1Zhgenmrjo=1hXf5uBWu9H_MgpYNJbK-xVHq7hekrUxs_pA@mail.gmail.com>
In-Reply-To: <CA+r1Zhgenmrjo=1hXf5uBWu9H_MgpYNJbK-xVHq7hekrUxs_pA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/2015 8:20 AM, Jim Davis wrote:
> Building with the attached random configuration file,
>
> security/smack/smack_netfilter.c: In function ‘smack_ipv4_output’:
> security/smack/smack_netfilter.c:55:6: error: ‘struct sk_buff’ has no
> member named ‘secmark’
>    skb->secmark = skp->smk_secid;
>       ^
> make[2]: *** [security/smack/smack_netfilter.o] Error 1

Yup. Problem in security/smack/Makefile. Patch imminent. 

