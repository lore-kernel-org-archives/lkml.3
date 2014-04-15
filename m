Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751045AbaDOLgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:36:21 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33993 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaDOLgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140415094015.GB1700@krava.brq.redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
 <878ur7thwh.fsf@sejong.aot.lge.com> <20140415094015.GB1700@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 15 Apr 2014 20:35:52 +0900
Message-ID: <CAM9d7cjJchw2ocEwv5a3tn5_GMfXNS8-sJcBiS8zd1oCSDprkw@mail.gmail.com>
Subject: Re: [RFC 0/5] perf: Create hist_entry groups
To: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Apr 15, 2014 at 6:40 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Apr 15, 2014 at 12:01:50PM +0900, Namhyung Kim wrote:
>> Another one I'd like to introduce is somewhat similar to your work.
>> It's called hierarchy view and groups each entries according to sort
>> keys [2].  But it only supported --gtk output at that time (in order not
>> to make the hands dirty unnecessarily ;-) and (thus?) didn't get much
>> review.  But I think the idea is same and requires less change by just
>> adding few fields (rb_root) to hist_entry instead of new data structure.
>
> hi,
> I dont recall seeing that [2], but it's one year back ;-) it looks like
> what Don is talking about, do you have it in branch?

Yep, it's perf/hierarchy-v1.

Thanks,
Namhyung
