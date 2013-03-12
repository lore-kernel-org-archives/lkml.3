Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3CLF7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:59:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36464 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3CLF7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:59:48 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-3e-513ec4529748
Message-id: <513EC452.4030700@samsung.com>
Date: Tue, 12 Mar 2013 14:59:46 +0900
From: Minkyu Kang <mk7.kang@samsung.com>
Organization: SAMSUNG ELECTRONICS
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221
 Thunderbird/17.0.3
MIME-version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] power: max17040_battery: Use dev_pm_ops
References: <1362922449-27531-1-git-send-email-lars@metafoo.de>
 <1362922449-27531-2-git-send-email-lars@metafoo.de>
In-reply-to: <1362922449-27531-2-git-send-email-lars@metafoo.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zPd2gI3aBBotOilj82rmN2WLiysnM
	Fksmz2e1uLxrDpsDi8fmFVoeU+YeYfVY8uYQq8fnTXIBLFFcNimpOZllqUX6dglcGZPOnWAs
	WMlc8ejjMuYGxsdMXYycHBICJhKffu2AssUkLtxbz9bFyMUhJLCMUeLFkVfMMEXN3/4zQySm
	M0o8+f6RFSQhJPCKUaJnbiWIzSugJTF5WydYA4uAqkT38VVgNWwCGhJPp21nBLH5BRQlZrS+
	YAOxRQXCJGZfP8sM0Sso8WPyPRYQWwSo/v+bSewgNrNApsTDpklgNcICDhL/Fz1ghthbKrH9
	4iSw+ZxA8c8XbkHV60jsb53GBmHLS2xe8xbsaAmBXewSJz+vZ4I4TkDi2+RDQMs4gBKyEpsO
	QD0pKXFwxQ2WCYzis5CcNAvJ2FlIxi5gZF7FKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERJl
	E3cw3j9gfYgxGWjlRGYp0eR8YJTmlcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoGx5vfR3OKFt1O6Dwec2ReSfk36uSAPx+llh8r52/NbstirhHb6
	dPyUb5JkyZr5M89g7vFXwQ5RsxiO5fwTK1jd7K+l+enw7cVTl9TvSVHcssz13bwlyyU3BE/f
	e+exiJhP84VFJr85nN7avfU3Erc7VcbXUHX5V/SxQ395gjWTr6VEcvbfKf6qxFKckWioxVxU
	nAgAZuPlmcgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd2gI3aBBl1r+S1+7dzGbDFx5WRm
	iyWT57NaXN41h82BxWPzCi2PKXOPsHoseXOI1ePzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xoxJ504wFqxkrnj0cRlzA+Njpi5GTg4JAROJ5m//mSFsMYkL99az
	dTFycQgJTGeUePL9IytIQkjgFaNEz9xKEJtXQEti8rZOsAYWAVWJ7uOrwGrYBDQknk7bzghi
	8wsoSsxofcEGYosKhEnMvn6WGaJXUOLH5HssILYIUP3/N5PYQWxmgUyJh02TwGqEBRwk/i96
	wAyxt1Ri+8VJYPM5geKfL9yCqteR2N86jQ3ClpfYvOYt8wRGwVlIVsxCUjYLSdkCRuZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEx/Ex6B+OqBotDjAIcjEo8vArfbAOFWBPLiitzDzFK
	cDArifBmbLYLFOJNSaysSi3Kjy8qzUktPsSYDAyNicxSosn5wPSSVxJvaGxiZmRpZGZsYm5s
	TJqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M0m3qSpcqI/YWrHxw5Ebr88i5exLWXZXd
	5mlueT1JzmaZf6vsxV1dT+NWJq4U/PP9X4HXUfkZz+ROV13IsTSabMJXb2J6b/9xjp4lhUc7
	rsj8sFDxWe5h16v6zWHuW77Zp4W7CxfppHm9e3Vf2LxB8+aL4w/fRW49kbY2+tT+HNcp6ccN
	+N62KbEUZyQaajEXFScCAL8svEolAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/13 22:34, Lars-Peter Clausen wrote:
> Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.
> 
> Cc: Minkyu Kang <mk7.kang@samsung.com>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/power/max17040_battery.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 

Acked-by: Minkyu Kang <mk7.kang@samsung.com>

Thanks,
Minkyu Kang.
