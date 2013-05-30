Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab3E3Uvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:51:54 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:35758 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3E3Uvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:51:48 -0400
X-WSS-ID: 0MNMPY9-0B-2DN-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <51A7BBC8.9050300@sandia.gov>
Date: Thu, 30 May 2013 14:51:20 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514
 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Chuck Lever" <chuck.lever@oracle.com>
cc: "Trond Myklebust" <Trond.Myklebust@netapp.com>,
        "Weston Andros Adamson" <dros@netapp.com>,
        "Linux NFS Mailing List" <linux-nfs@vger.kernel.org>,
        "LKML Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 3.10-rc3 NFSv3 mount issues
References: <51A7B442.9010108@sandia.gov>
 <D74C8145-AD4D-4CFE-963C-643B8D7DBA10@oracle.com>
In-Reply-To: <D74C8145-AD4D-4CFE-963C-643B8D7DBA10@oracle.com>
X-TMWD-Spam-Summary: TS=20130530205123; ID=1; SEV=2.3.1;
 DFV=B2013022509; IFV=NA; AIF=B2013022509; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230372E35314137424243422E303032433A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAABAJsKIgAAAAAAAAAAAAAAAAAAAH0=
X-MMS-Spam-Filter-ID: B2013022509_5.03.0010
X-WSS-ID: 7DB964422IW3330236-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 02:26 PM, Chuck Lever wrote:
> 
> On May 30, 2013, at 4:19 PM, Jim Schutt <jaschut@sandia.gov> wrote:
> 
>> Hi,
>>
>> I've been trying to test 3.10-rc3 on some diskless clients, and found
>> that I can no longer mount my root file system via NFSv3.
>>

> 
> 3.10-rc3 appears to be missing the fix for this.  See:
> 
>   http://marc.info/?l=linux-nfs&m=136855668104598&w=2
> 
> Trond, can we get this applied?
> 

That works for me.

Thanks!

-- Jim


