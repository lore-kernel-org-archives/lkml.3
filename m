Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaLWEfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:35:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:46596 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaLWEfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:35:03 -0500
X-AuditID: cbfee691-f79b86d000004a5a-ca-5498f0f42aac
Message-id: <5498F0F4.7020700@samsung.com>
Date: Tue, 23 Dec 2014 13:35:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: myungjoo.ham@samsung.com, kgene.kim@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>, rafael.j.wysocki@intel.com,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, k.kozlowski@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCHv5 3/9] devfreq: event: Add exynos-ppmu devfreq-event driver
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
 <1419304697-14789-4-git-send-email-cw00.choi@samsung.com>
 <CAEUmHyYnb8_HNnuz8BLhMOh01+gpXfTv63P-ubYE1DK9uptonA@mail.gmail.com>
In-reply-to: <CAEUmHyYnb8_HNnuz8BLhMOh01+gpXfTv63P-ubYE1DK9uptonA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWyRsSkQPfLhxkhBo0H9C0er1nMZDH/yDlW
	i0n3J7BYvH5haNG74CqbxdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyWHr9IpPF7cYVbBaP
	V7xlt1i16w+jxcmOOYwO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6MZed+MhZ816hY+OY3SwPjGukuRk4OCQETiZnbW1ggbDGJC/fWs3UxcnEICSxl
	lJj+cz0LTFHLmXPMEIlFjBJ/l61lhHBeM0rMO3OQGaSKV0BL4tvb02wgNouAqsTK+7vYQWw2
	oPj+FzfA4qICYRIrp19hgagXlPgx+R6QzcEhAlRz5qMIyExmgUksEtdmN4DVCwv4Syw/f5cV
	YtkJRommUw2sIAlOgWCJLR+egA1iFlCXmDRvETOELS+xec1bsFMlBHo5JNafmMQIcZGAxLfJ
	h8C2SQjISmw6wAzxmqTEwRU3WCYwis1CctMsJGNnIRm7gJF5FaNoakFyQXFSepGpXnFibnFp
	Xrpecn7uJkZgRJ/+92ziDsb7B6wPMQpwMCrx8C44MyNEiDWxrLgy9xCjKdAVE5mlRJPzgWkj
	ryTe0NjMyMLUxNTYyNzSTEmcV0f6Z7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxmK3PpUe
	Fm2b9SWBt7aF/E3WXMfsqbbJcqOJsqr3o9sPG7vLT0sp//T/qhV0vi/ay/26WeKrrAg3jXVH
	F5m3HXV1VZ3jsqb358Hj0zX1Nf8HetuEFxwQ4C86+t9gy7U1FbOLphjzs7Atu/pG9VvDVxb3
	w78r16woDTcsN7t17nlobPQG3xWKSizFGYmGWsxFxYkA5WsHFOMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd0vH2aEGDR2q1s8XrOYyWL+kXOs
	FpPuT2CxeP3C0KJ3wVU2i7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbrFq1x9Gi5Mdcxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJysplCXmlAKF
	AhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM5ad+8lY8F2jYuGb3ywNjGukuxg5OSQE
	TCRazpxjhrDFJC7cW8/WxcjFISSwiFHi77K1jBDOa0aJeWcOglXxCmhJfHt7mg3EZhFQlVh5
	fxc7iM0GFN//4gZYXFQgTGLl9CssEPWCEj8m3wOyOThEgGrOfBQBmcksMIlF4trsBrB6YQF/
	ieXn77JCLDvBKNF0qoEVJMEpECyx5cMTsEHMAuoSk+YtYoaw5SU2r3nLPIFRYBaSHbOQlM1C
	UraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnC6eCa1g3Flg8UhRgEORiUe3gVnZoQI
	sSaWFVfmHmKU4GBWEuFVbwUK8aYkVlalFuXHF5XmpBYfYjQFBsFEZinR5HxgKssriTc0NjEz
	sjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUAiYK9fUJT2W4ONn/za9uvXI67GLp
	n2seTatr1y9wfaVX4PynrM3zUmH9idCbX+punvERzbqlJGS598rRmz/PtgV9dlz7ju3PJ9lF
	1wXz67rlzzbtar3w/P/f5oCpjgkv9h7JYdJ5p9K3hvfjp7DofrkkxT7Lds34qEa+nLoPptM4
	D/+8N2/L86lKLMUZiYZazEXFiQDvUbzoLQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 12:40 PM, Varka Bhadram wrote:
> On Tue, Dec 23, 2014 at 8:48 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch adds exynos-ppmu devfreq-event driver to get performance data
>> of each IP for Samsung Exynos SoC. These event from Exynos PPMU provide
>> useful information about the behavior of the SoC that you can use when
>> analyzing system performance, and made visible and can be counted using
>> logic in each IP.
>>
>> This patch is based on existing drivers/devfreq/exynos/exynos-ppmu.c
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> (...)
>> +static int exynos_ppmu_parse_dt(struct exynos_ppmu_data *data)
>> +{
>> +       struct device *dev = data->dev;
>> +       struct device_node *np = dev->of_node;
>> +       int ret = 0;
>> +
>> +       if (!np) {
>> +               dev_err(dev, "failed to find devicetree node\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* Maps the memory mapped IO to control PPMU register */
>> +       data->ppmu.base = of_iomap(np, 0);
>> +       if (IS_ERR_OR_NULL(data->ppmu.base)) {
>> +               dev_err(dev, "failed to map memory region\n");
>> +               return -EINVAL;
> -ENOMEM or -ENXIO is the proper error return value..?

OK. I'll return -ENOMEM value.

> 
>> +       }
>> +
>> +       data->clk_ppmu = devm_clk_get(dev, "ppmu");
>> +       if (IS_ERR(data->clk_ppmu)) {
>> +               data->clk_ppmu = NULL;
>> +               dev_warn(dev, "failed to get PPMU clock\n");
>> +       }
> If PPMU clk get fails..?  return PTR_ERR(data->clk_ppmu)

If Exynos SoC don't register the clock to clock tree, the clock remains on state.
So, I print just warning message.

But, It is not proper. I'll fix it.

>> +
>> +       ret = of_get_devfreq_events(np, data);
>> +       if (ret < 0) {
>> +               dev_err(dev, "failed to parse exynos ppmu dt node\n");
>> +               goto err;
>> +       }
>> +
>> +       return 0;
>> +
>> +err:
>> +       iounmap(data->ppmu.base);
>> +
>> +       return ret;
>> +}
>> +
>> +static int exynos_ppmu_probe(struct platform_device *pdev)
>> +{
>> +       struct exynos_ppmu_data *data;
>> +       struct devfreq_event_dev **edev;
>> +       struct devfreq_event_desc *desc;
>> +       int i, ret = 0, size;
>> +
>> +       data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
>> +       if (!data)
>> +               return -ENOMEM;
>> +
>> +       mutex_init(&data->lock);
>> +       data->dev = &pdev->dev;
>> +
>> +       /* Parse dt data to get resource */
>> +       ret = exynos_ppmu_parse_dt(data);
>> +       if (ret < 0) {
>> +               dev_err(&pdev->dev,
>> +                       "failed to parse devicetree for resource\n");
>> +               return ret;
>> +       }
>> +       desc = data->desc;
>> +
>> +       size = sizeof(struct devfreq_event_dev *) * data->num_events;
>> +       data->edev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
>> +       if (!data->edev) {
>> +               dev_err(&pdev->dev,
>> +                       "failed to allocate memory devfreq-event devices\n");
>> +               return -ENOMEM;
>> +       }
>> +       edev = data->edev;
>> +       platform_set_drvdata(pdev, data);
>> +
>> +       for (i = 0; i < data->num_events; i++) {
>> +               edev[i] = devfreq_event_add_edev(&pdev->dev, &desc[i]);
>> +               if (IS_ERR(edev)) {
>> +                       ret = PTR_ERR(edev);
>> +                       dev_err(&pdev->dev,
>> +                               "failed to add devfreq-event device\n");
>> +                       goto err;
>> +               }
>> +       }
>> +
>> +       clk_prepare_enable(data->clk_ppmu);
>> +
>> +       return 0;
>> +err:
>> +       iounmap(data->ppmu.base);
>> +
>> +       return ret;
>> +}
>> +
>> +static int exynos_ppmu_remove(struct platform_device *pdev)
>> +{
>> +       struct exynos_ppmu_data *data = platform_get_drvdata(pdev);
>> +       int i, ret = 0;
>> +
>> +       for (i = 0; i < data->num_events; i++) {
>> +               ret = devfreq_event_remove_edev(data->edev[i]);
>> +               if (ret < 0) {
>> +                       dev_err(&pdev->dev,
>> +                               "failed to remove devfreq-event device\n");
>> +                       goto err;
>> +               }
>> +       }
>> +
>> +err:
>> +       clk_disable_unprepare(data->clk_ppmu);
>> +       iounmap(data->ppmu.base);
>> +
>> +       return ret;
>> +}
>> +
>> +static struct of_device_id exynos_ppmu_id_match[] = {
>> +       { .compatible = "samsung,exynos-ppmu", },
>> +       { /* sentinel */ },
>> +};
>> +
>> +static struct platform_driver exynos_ppmu_driver = {
>> +       .probe  = exynos_ppmu_probe,
>> +       .remove = exynos_ppmu_remove,
>> +       .driver = {
>> +               .name   = "exynos-ppmu",
>> +               .owner  = THIS_MODULE,
> remove owner field. It will be populate by driver core.

OK. I'll remove it.

Thanks for your review.

Best Regards,
Chanwoo Choi
