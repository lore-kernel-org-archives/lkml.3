Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3FJSyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:54:19 -0400
Received: from nm22-vm1.bullet.mail.bf1.yahoo.com ([98.139.212.127]:44159 "EHLO
	nm22-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab3FJSyR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:54:17 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 14:54:17 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 559964.34716.bm@omp1004.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Qqjs8Uw7jtEMaGizRajvvVsjtVc0dNh5pKrZyaLTBoOpou8DTGrXd8x+GljW2IZNzj0MbKhUB5LgecMVPkK8eEWxRhXw81VmC+SkG44QWMOCbP9izCQ3b7LjUp3h0SCwBqfMyXPZ+jPOINMWj8RGacTKy5ZKd+Du4jfL6faFOVY=;
X-YMail-OSG: noFg58MVM1ms5t3iciGv4M4DMM18r9LUsfDcJgoOmkMg7Zs
 uZToSU6RZ0GI8ClcuXfM8WULdRjjBrxzrtCAIYNVZqXDu11tP5ZxBuE8Sb4a
 U_AvwseAfo12orRb_rrzr7Eyqj7NiUZDRpeU6O8mdV_pjGh2qF5q4bgRRCin
 P64mDDlh8XNBsAHW2iHhkSlCChcbyDjrw38.PFQy9Hk4R6PeU6F.3vQBCk.x
 63BYMkuRXHY9FmlS5EMPzRZEMccWXim5AE1HnGYcufu87uA24.6ASLkoIV4k
 SgVDtGTt_kP0XEe6yHU59.5RMDFjTqfE8YBZ0z7ZTTyGv5Ys5GaIxjXxt0BK
 u3I_Tt_gr8.RbITW3A3pq.DcloRJ_TDBbkZEr0uQ.ekK1wy3DdP5uIdq5B_E
 7waXb48c1MdtXwNrDXoATI5FaJvUEqMsPnoHuoP6S8K1g1R0OdEGzjO9eCsS
 wV_nAngfDgcwkw.XBvPakbFBroipPAKDhMwV9eiKVS5IDn33wkLNN.6T5Vk_
 5DLMU_LYl0229ViwTjBYXY4FwmUEs4q8pbGAiPMiEJtFQY8ga.3gFSOkxk5l
 HDkdKsh03vPoJyu0cZNpxrittcfKXy_q8QWCXdXkg6h8Ax6GUZBA2jSFgqZm
 U0oXUmzGkq32sOAAqYSaL9UHTZNTJFYcIPspWps98ckfr8TYYfBT1zAyRaOe
 TaBr92TcwWqDTv0Kvyp6hBBuu74TLgcWu1V6JtA.KUfChG66qvszrQhN0It9
 v.LPCrhLqHdgQ
X-Rocket-MIMEInfo: 002.001,Pl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4gRnJvbTogYW5pc2ggc2luZ2ggPGFuaXNoMTk4NTE5ODUxOTg1QGdtYWlsLmNvbT4KPlRvOiBQSU5UVSBLVU1BUiA8cGludHVfYWdhcndhbEB5YWhvby5jb20.IAo.Q2M6ICJsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47ICJsaW51eC1tbUBrdmFjay5vcmciIDxsaW51eC1tbUBrdmFjay5vcmc.IAo.U2VudDogU3VuZGF5LCA5IEp1bmUgMjAxMyAxMDo1OCBQTQo.U3ViamVjdDogUmU6IFsBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.146.552
References: <1370843475.58124.YahooMailNeo@web160106.mail.bf1.yahoo.com> <CAK7N6vrQFK=9OQi7dDUgGWWNQk71x3BeqPA9x3Pq66baA61PrQ@mail.gmail.com>
Message-ID: <1370890140.99216.YahooMailNeo@web160102.mail.bf1.yahoo.com>
Date: Mon, 10 Jun 2013 11:49:00 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [checkpatch] - Confusion
To: anish singh <anish198519851985@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <CAK7N6vrQFK=9OQi7dDUgGWWNQk71x3BeqPA9x3Pq66baA61PrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>________________________________
> From: anish singh <anish198519851985@gmail.com>
>To: PINTU KUMAR <pintu_agarwal@yahoo.com> 
>Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "linux-mm@kvack.org" <linux-mm@kvack.org> 
>Sent: Sunday, 9 June 2013 10:58 PM
>Subject: Re: [checkpatch] - Confusion
> 
>
>On Mon, Jun 10, 2013 at 11:21 AM, PINTU KUMAR <pintu_agarwal@yahoo.com> wrote:
>> Hi,
>>
>> I wanted to submit my first patch.
>> But I have some confusion about the /scripts/checkpatch.pl errors.
>>
>> After correcting some checkpatch errors, when I run checkpatch.pl, it showed me 0 errors.
>> But when I create patches are git format-patch, it is showing me 1 error.
>did  you run the checkpatch.pl on the file which gets created
>after git format-patch?
>If yes, then I think it is not necessary.You can use git-am to apply
>your own patch on a undisturbed file and if it applies properly then
>you are good to go i.e. you can send your patch.

Yes, first I ran checkpatch directly on the file(mm/page_alloc.c) and fixed all the errors.
It showed me (0) errors.
Then I created a patch using _git format-patch_ and ran checkpatch again on the created patch.
But now it is showing me 1 error.
According to me this error is false positive (irrelevant), because I did not change anything related to the error and also the similar change already exists somewhere else too.
Do you mean, shall I go ahead and submit the patch with this 1 error??
ERROR: need consistent spacing around '*' (ctx:WxV)

#153: FILE: mm/page_alloc.c:5476:
+int min_free_kbytes_sysctl_handler(ctl_table *table, int write,



>>
>> If I fix error in patch, it showed me back again in files.
>>
>> Now, I am confused which error to fix while submitting patches, the file or the patch errors.
>>
>> Please provide your opinion.
>>
>> File: mm/page_alloc.c
>> Previous file errors:
>> total: 16 errors, 110 warnings, 6255 lines checked
>>
>> After fixing errors:
>> total: 0 errors, 105 warnings, 6255 lines checked
>>
>>
>> And, after running on patch:
>> ERROR: need consistent spacing around '*' (ctx:WxV)
>> #153: FILE: mm/page_alloc.c:5476:
>> +int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
>>
>>
>>
>>
>> - Pintu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>--
>To unsubscribe, send a message with 'unsubscribe linux-mm' in
>the body to majordomo@kvack.org.  For more info on Linux MM,
>see: http://www.linux-mm.org/ .
>Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
>
>
