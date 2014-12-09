Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbaLILXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:23:46 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53701 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbaLILXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:23:43 -0500
From: "Javi Merino" <javi.merino@arm.com>
Date: Tue, 9 Dec 2014 11:23:39 +0000
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
Message-ID: <20141209112339.GE2891@e104805>
References: <1417806260-9264-7-git-send-email-javi.merino@arm.com>
 <CAOh2x==BKyS08th2d4r0Q2UGqhzAwj6sqOgFsH6J0pWup+OU_A@mail.gmail.com>
 <20141208125033.GB2980@e104805>
 <CAKohpokM_8Qm5YH0Xb=n95bP94Qreqpcd1fAyCD2W5u9Pd=ndg@mail.gmail.com>
 <20141208142217.GA1831@e104805>
 <CAKohpomy7=v_qE3B_+hhwdUE8MCJkV7gzmPpUOb==t1BuZAnAA@mail.gmail.com>
 <20141209103249.GB2891@e104805>
 <CAKohpokBVH2gnqBrDffPMcsYx6BNKFvMWkNM4D3DzU8nxb=-xw@mail.gmail.com>
 <20141209110043.GD2891@e104805>
 <CAKohpomJyucC6pYTTc3iOMWFi0_MnEejVOpttiFR7v6ksFieJg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKohpomJyucC6pYTTc3iOMWFi0_MnEejVOpttiFR7v6ksFieJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Dec 2014 11:23:40.0385 (UTC) FILETIME=[95474510:01D013A2]
X-MC-Unique: 114120911234109601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 11:06:46AM +0000, Viresh Kumar wrote:
> On 9 December 2014 at 16:30, Javi Merino <javi.merino@arm.com> wrote:
> > Ok, how about this then?  I've pasted the whole commit so as to avoid
> > confusion.
> 
> Yeah, the cpu_dev part looks fine now.

Great, thanks!

