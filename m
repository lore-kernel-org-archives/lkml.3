Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab3HWTZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:25:13 -0400
Received: from mout.gmx.net ([212.227.17.20]:60196 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3HWTZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:25:11 -0400
MIME-Version: 1.0
Message-ID: <trinity-386b7d66-03ef-4db7-a57a-9e69a71300d4-1377285909862@3capp-gmx-bs55>
From: "Andreas Werner" <wernerandy@gmx.de>
To: "Andy Lutomirski" <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: question about ioremap_cache and PAT
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 Aug 2013 21:25:09 +0200 (CEST)
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K0:viI+NrFWmXgFV9PnNpmMI1OkKrGHZ+9DfbmgSfGzrYS
 PPwOioIMDxMMcJWOtLv98xY1m9zWXQp6l26f8ZO2WxyWkZ9BmJ
 60D1LfzfihNDx9dONH/NehsXofJQiLkxUDXWnnJEzATBjWw2yy
 0KkRmSHLk1ew6npb57zpaYMUvbhBWbafR8FbmQIOWNlsKfYfh+
 fiz3VzBOpPy6MD5sNocH5L83pkiRD8usmP5nlTHlQybgbyBiW/
 L0V+Xq63/Sd+KtF9XqV+TBHgfm6ZrQWr/SvtEWycQMG1i/WSbA K7sgTE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Aug 23, 2013 at 11:18 AM, Andreas Werner <wernerandy@gmx.de>
> wrote:
>> Hi,
>>
>> why are you curious?
>>
>> I have never heard about movntdqa. Have you ever tried it?
>> May be it is a good idea to try i out.
> 
> I've never tried it, but in theory it should be comparably fast as
> compared to WT.
> 
> --Andy
> 
Ok thank you for your help and information.
But why are you curious?

Is the solution with WT and WB and clflush so particular? I tried a lot to get this working, but this was the only way to get it working.

Do you know if there is an inline function for movntdqa in the linux kernel?
