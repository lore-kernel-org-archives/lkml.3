Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3GXJOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:14:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36581 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3GXJOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:14:33 -0400
X-AuditID: cbfee68e-b7f276d000002279-de-51ef9af7f9c4
Message-id: <51EF9AF7.60007@samsung.com>
Date: Wed, 24 Jul 2013 18:14:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 1/3 v6] cpufreq: Add debugfs directory for cpufreq
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
 <1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
 <CAKohpo=oTsEjzi_51UaZ8ww8UEfZ6hwKAnu9rFgGBkt=TfHi8A@mail.gmail.com>
 <51EF2D06.7000704@samsung.com>
 <CAKohpok7B6DaqFPWZcODEgK5GRSoAQYZ27-h2=AQ1HBBP4gH8Q@mail.gmail.com>
 <51EF8590.7030405@samsung.com>
 <CAKohpom19C7JHSX6w31pSDrwcAR_PZn1HzP0Jui5iZL=bALDPQ@mail.gmail.com>
 <51EF945E.3080802@samsung.com>
 <CAKohpo=_3iR44XfxuRAmw-9DDk9APniWH=efd72v845wH3C-DQ@mail.gmail.com>
 <51EF98DD.4010607@samsung.com>
 <CAKohpon02iZpB7BVwdJR69Ne=8GbL0z76D7ExtAahCE-R_vnnA@mail.gmail.com>
In-reply-to: <CAKohpon02iZpB7BVwdJR69Ne=8GbL0z76D7ExtAahCE-R_vnnA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkUPf7rPeBBquaVS2eNv1gtzjb9Ibd
	4v2hZ8wWl3fNYbP43HuE0eJ24wo2i/6FvUwWG796OHB43Lm2h83j9r/HzB59W1Yxejxa3MLo
	8XmTXABrFJdNSmpOZllqkb5dAlfG268bmQqWclTcvLOOsYFxO1sXIyeHhICJROPrl+wQtpjE
	hXvrweJCAksZJW5OtoKp2f64k7mLkQsovohR4tGeE1DOK0aJJS/WsYBU8QpoSCx/8Z8VxGYR
	UJV49PA2M4jNJqAlsf/FDbCpogJhEiunX4GqF5T4MfkekM3BIQJU8/JmKshMZoHzjBK7/58D
	6xUWcJM4f6+bDWLZMxaJm+t+gzVzCgRLvPmyAOxsZgEdif2t09ggbHmJzWvegl0nIXCNXWLu
	h5vMEBcJSHybfAhsm4SArMSmA8wQr0lKHFxxg2UCo9gsJDfNQjJ2FpKxCxiZVzGKphYkFxQn
	pRcZ6RUn5haX5qXrJefnbmIERuDpf8/6djDePGB9iDEZaOVEZinR5HxgBOeVxBsamxlZmJqY
	GhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZGrUtWdUXNr5k/274fi
	QmMkT53bt/XUh8/rgv1uaZRcWajDXy89pz7ib8DvxOoLBydq2wVuY3Hz8OVVddlyu403T+H8
	62m756+ZyNz+2S3o5tqsL5sZZrCyXF04+cbUuOv1F99/lD3A8fLC1A967qfb0neydeYaZXgv
	9Ng3Iz5tne+MNaWyu/iVWIozEg21mIuKEwGGrWdG1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAd3vs94HGjydLmvxtOkHu8XZpjfs
	Fu8PPWO2uLxrDpvF594jjBa3G1ewWfQv7GWy2PjVw4HD4861PWwet/89Zvbo27KK0ePR4hZG
	j8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTd
	MnOAblFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZrz9upGpYClHxc07
	6xgbGLezdTFyckgImEhsf9zJDGGLSVy4tx4ozsUhJLCIUeLRnhPMEM4rRoklL9axgFTxCmhI
	LH/xnxXEZhFQlXj08DZYN5uAlsT+FzfApooKhEmsnH4Fql5Q4sfke0A2B4cIUM3Lm6kgM5kF
	zjNK7P5/DqxXWMBN4vy9bqjNz1gkbq77DdbMKRAs8ebLAnYQm1lAR2J/6zQ2CFteYvOat8wT
	GAVmIdkxC0nZLCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/gz6R2MqxosDjEK
	cDAq8fAWzHoXKMSaWFZcmXuIUYKDWUmEt2Xa+0Ah3pTEyqrUovz4otKc1OJDjMnAIJjILCWa
	nA9MPnkl8YbGJmZGlkbmhhZGxuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLgpdZ6Y
	3l93u4uF078u9Nx6esqSjc2Pd74/H8RbWHLuh5rxR9tf3nef3Vop73rXe88Z/qir32en3p8j
	KfH0uEd9+KSarS8nVcaE7D6/TyxN+VGA7LWnHWIRhc76jfz7Vjw4FdiQGRlbljvv4tvERKtb
	4sZyc2U/XmH3zz7/mct7ecPLitXyc84osRRnJBpqMRcVJwIA/47JmzQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 06:09 PM, Viresh Kumar wrote:
> On 24 July 2013 14:35, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> And, I add additional step on below:
>>
>>> - Remove symlink for new policy->cpu, i..e cpu1 in your example
>>> - rename debugfs entry to give it to cpu1 instead of cpu0.
>>   - Store renamed cpu0 pointer to cpu1 pointer
>>   - Create new link for CPU[2-3] to CPU1's debugfs directory
>>         because debugfs use string path to create symbolic link.
>>         It isn't automatically connected with new CPU1 debugfs directory.
> 
> Honestly speaking I am not the best at debugfs core, but I still think
> the link is connected to a struct debugfs node and not to any path..
> This node is connected to a path though. And so even after rename
> things should stay stable without your new step...
> 
> Just try and see if I am right or wrong.. Otherwise what you already
> did is correct as you need to remove links for 2-3 as well..
> 

OK, I'll try it according to your suggestion. Thanks.

Best Regards,
Chanwoo Choi
